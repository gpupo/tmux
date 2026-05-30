#!/usr/bin/env bash
# =============================================================================
#  popup-toggle.sh — Toggle de popup persistente sobre ~/work/
# =============================================================================
#
#  Acionado por: C-s → Enter  (modo SESSIONS)
#
#  COMPORTAMENTO
#  ─────────────
#  • Fora do tmux  → anexa diretamente à sessão "popup".
#  • Dentro do tmux, na sessão "popup" → desanexa (fecha o popup).
#  • Dentro do tmux, em outra sessão  → abre popup 80×80% conectado
#    à sessão persistente.
#
#  A sessão "popup" é criada automaticamente na primeira vez.
#  Ela sobrevive ao fechar o popup e mantém seu estado (histórico,
#  processos em background, etc.).
#
#  CUSTOMIZAÇÃO
#  ────────────
#  Altere `workdir` para o diretório que deve abrir no popup.
#  Descomente `tmux send-keys` para rodar um comando inicial.

set -euo pipefail

SESSION="popup"
WORKDIR="$HOME/work"

# ── Fora do tmux: entra direto na sessão ──────────────────────────────────
if [[ -z "${TMUX:-}" ]]; then
    tmux new-session -A -s "$SESSION" -c "$WORKDIR"
    exit 0
fi

current_session="$(tmux display-message -p '#{session_name}')"

# ── Toggle: já está na sessão popup → fecha ───────────────────────────────
if [[ "$current_session" == "$SESSION" ]]; then
    tmux detach-client
    exit 0
fi

# ── Cria sessão se não existir ────────────────────────────────────────────
if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux new-session -d -s "$SESSION" -c "$WORKDIR"
    tmux send-keys -t "$SESSION" "clear" C-m
    # Descomente para rodar um comando ao criar:
    # tmux send-keys -t "$SESSION" "ls -la" C-m
fi

# ── Abre popup conectado à sessão persistente ─────────────────────────────
tmux popup \
    -d "$WORKDIR" \
    -xC -yC \
    -w80% -h80% \
    -E \
    "tmux attach-session -t $SESSION"
