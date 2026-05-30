#!/usr/bin/env bash
# =============================================================================
#  tool-window.sh — Abre ou reutiliza uma janela tmux para uma ferramenta
# =============================================================================
#
#  Uso: tool-window.sh <nome-da-janela> <comando> [caminho]
#
#  Argumentos:
#    nome-da-janela  Nome único que identifica a janela (ex: LazyGit)
#    comando         Executável a rodar (ex: lazygit)
#    caminho         Diretório de trabalho (padrão: diretório do painel atual)
#
#  COMPORTAMENTO
#  ─────────────
#  • Se a janela já existe na sessão atual → navega até ela (sem duplicar).
#  • Se não existe → cria uma nova janela com o comando no diretório dado.
#
#  Isso garante que cada ferramenta tenha exatamente uma janela dedicada
#  e que o preset "dev" e o modo TOOLS (C-g) compartilhem as mesmas janelas.
#
#  OBSERVABILIDADE
#  ───────────────
#  Cada ação é registrada em:
#    $XDG_STATE_HOME/tool-window.log  (padrão: ~/.local/state/tool-window.log)
#  Sobreponha com: TOOL_WINDOW_LOG=/outro/caminho tool-window.sh ...
#
#  DEPENDÊNCIAS: tmux

set -euo pipefail

# ── Log ───────────────────────────────────────────────────────────────────
LOG_FILE="${TOOL_WINDOW_LOG:-${XDG_STATE_HOME:-$HOME/.local/state}/tool-window.log}"
mkdir -p "$(dirname "$LOG_FILE")"

_log() {
    local level="$1"; shift
    printf '%s [%s] tool-window: %s\n' \
        "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$level" "$*" >> "$LOG_FILE"
}

_ts_start=$(date +%s%3N)

# ── Argumentos ────────────────────────────────────────────────────────────
WINDOW_NAME="$1"
COMMAND="$2"
DIR="${3:-$(tmux display-message -p '#{pane_current_path}')}"

_log INFO "start window_name=${WINDOW_NAME} command=${COMMAND} dir=${DIR}"

# ── Lógica principal ──────────────────────────────────────────────────────

# Procura janela pelo nome na sessão atual
WINDOW=$(tmux list-windows -F '#{window_index}:#{window_name}' \
    | grep ":${WINDOW_NAME}$" \
    | head -1 \
    | cut -d: -f1) || true

if [[ -n "$WINDOW" ]]; then
    # Janela já existe → apenas navega até ela
    _log INFO "action=reuse window_index=${WINDOW}"
    tmux display-message "→ ${WINDOW_NAME}"
    tmux select-window -t "$WINDOW"
else
    # Janela não existe → cria com o comando no diretório especificado
    _log INFO "action=create window_name=${WINDOW_NAME}"
    tmux display-message "→ abrindo ${COMMAND}"
    tmux new-window -c "$DIR" -n "$WINDOW_NAME" "$COMMAND"
fi

_ts_end=$(date +%s%3N)
_log INFO "done duration_ms=$(( _ts_end - _ts_start ))"
