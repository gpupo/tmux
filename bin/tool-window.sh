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
#  OBSERVABILIDADE (opt-in)
#  ────────────────────────
#  Por padrão o log está DESLIGADO para máxima performance.
#  Para habilitar, exporte a variável antes de rodar:
#
#    TOOL_WINDOW_DEBUG=1 tool-window.sh LazyGit lazygit /path
#
#  O log é gravado em:
#    ${XDG_STATE_HOME:-~/.local/state}/tool-window.log
#  Ou sobreponha com: TOOL_WINDOW_LOG=/outro/caminho
#
#  DEPENDÊNCIAS: tmux, bash ≥ 5 (para $EPOCHREALTIME no modo debug)

set -euo pipefail

WINDOW_NAME="$1"
COMMAND="$2"
DIR="${3:-}"

# ── Log (só inicializa se TOOL_WINDOW_DEBUG=1) ────────────────────────────
if [[ -n "${TOOL_WINDOW_DEBUG:-}" ]]; then
    LOG_FILE="${TOOL_WINDOW_LOG:-${XDG_STATE_HOME:-$HOME/.local/state}/tool-window.log}"
    mkdir -p "$(dirname "$LOG_FILE")"
    _ts_start="${EPOCHREALTIME}"   # builtin bash 5+ — zero fork

    _log() {
        local level="$1"; shift
        # printf com EPOCHREALTIME: preciso e sem fork externo
        printf '%.6f [%s] tool-window: %s\n' \
            "${EPOCHREALTIME}" "$level" "$*" >> "$LOG_FILE"
    }

    _log INFO "start window_name=${WINDOW_NAME} command=${COMMAND} dir=${DIR:-<pane>}"
else
    _log() { :; }   # no-op
fi

# ── Diretório (fallback para o painel atual só se não foi passado) ─────────
# Evita fork desnecessário de `tmux display-message` quando o chamador
# já fornece o caminho (como todos os binds em tmux.conf fazem).
[[ -z "$DIR" ]] && DIR="$(tmux display-message -p '#{pane_current_path}')"

# ── Busca janela pelo nome usando filtro nativo do tmux ───────────────────
# -f '#{==:...}' filtra server-side: evita pipeline grep+cut e é mais seguro
# com nomes que contenham caracteres especiais.
WINDOW=$(tmux list-windows \
    -F '#{window_index}' \
    -f "#{==:#{window_name},${WINDOW_NAME}}" \
    | head -1)

if [[ -n "$WINDOW" ]]; then
    _log INFO "action=reuse window_index=${WINDOW}"
    tmux select-window -t "$WINDOW"
else
    _log INFO "action=create window_name=${WINDOW_NAME}"
    tmux new-window -c "$DIR" -n "$WINDOW_NAME" "$COMMAND"
fi

if [[ -n "${TOOL_WINDOW_DEBUG:-}" ]]; then
    _elapsed=$(awk -v s="${_ts_start}" -v e="${EPOCHREALTIME}" \
        'BEGIN { printf "%.0f", (e - s) * 1000 }')
    _log INFO "done duration_ms=${_elapsed}"
fi
