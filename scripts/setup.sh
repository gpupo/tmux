#!/usr/bin/env bash
# =============================================================================
#  scripts/setup.sh — Instala a configuração tmux via symlinks
# =============================================================================
#
#  USO
#  ───
#    bash scripts/setup.sh
#
#  O QUE FAZ
#  ─────────
#  1. Detecta o diretório raiz deste repositório.
#  2. Cria ~/.tmux.conf apontando para tmux.conf do repositório.
#  3. Cria ~/.config/tmux → repositório (para scripts, docs, etc.).
#  4. Garante que todos os scripts em bin/ são executáveis.
#  5. (Opcional) Instala o TPM se não estiver presente.
#
#  IDEMPOTENTE — pode ser rodado várias vezes sem efeitos colaterais.

set -euo pipefail

# ── Cores para output ─────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

ok()   { echo -e "${GREEN}✔${RESET}  $*"; }
warn() { echo -e "${YELLOW}⚠${RESET}  $*"; }
err()  { echo -e "${RED}✖${RESET}  $*" >&2; }

# ── Diretório do repositório ──────────────────────────────────────────────
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ok "Repositório detectado: $REPO_DIR"

# ── Helper: cria symlink com backup ──────────────────────────────────────
link() {
    local src="$1"
    local dst="$2"

    if [[ -L "$dst" ]]; then
        if [[ "$(readlink "$dst")" == "$src" ]]; then
            ok "Symlink já existe: $dst → $src"
            return
        fi
        warn "Symlink desatualizado — recriando: $dst"
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        local backup="${dst}.backup.$(date +%Y%m%d%H%M%S)"
        warn "Arquivo existente salvo como: $backup"
        mv "$dst" "$backup"
    fi

    ln -s "$src" "$dst"
    ok "Criado: $dst → $src"
}

# ── 1. ~/.tmux.conf ────────────────────────────────────────────────────────
link "$REPO_DIR/tmux.conf" "$HOME/.tmux.conf"

# ── 2. ~/.config/tmux ─────────────────────────────────────────────────────
# O tmux.conf referencia scripts como $HOME/.config/tmux/bin/<script>
# e documentos como $HOME/.config/tmux/docs/<arquivo>.
mkdir -p "$HOME/.config"
link "$REPO_DIR" "$HOME/.config/tmux"

# ── 3. Permissões dos scripts ─────────────────────────────────────────────
chmod +x "$REPO_DIR"/bin/*
ok "Scripts em bin/ marcados como executáveis"

# ── 4. TPM (Tmux Plugin Manager) — opcional ───────────────────────────────
TPM_DIR="$HOME/.tmux/plugins/tpm"

if [[ -d "$TPM_DIR" ]]; then
    ok "TPM já instalado: $TPM_DIR"
else
    echo ""
    read -r -p "Instalar o TPM agora? [s/N] " install_tpm
    if [[ "${install_tpm:-N}" =~ ^[sS]$ ]]; then
        git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
        ok "TPM instalado em $TPM_DIR"
    else
        warn "TPM não instalado. Rode manualmente ou abra o tmux — ele instalará automaticamente."
    fi
fi

# ── 5. Resumo ─────────────────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════════════"
ok "Setup concluído!"
echo ""
echo "  Próximos passos:"
echo "  1. Abra o tmux (ou reload com <prefix> + r)"
echo "  2. Pressione <prefix> + I para instalar plugins via TPM"
echo "  3. Pressione C-g ? para abrir a referência de atalhos"
echo "════════════════════════════════════════════════"
