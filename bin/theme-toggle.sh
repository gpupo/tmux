#!/usr/bin/env bash
# =============================================================================
#  theme-toggle.sh — Alterna entre tema claro (Day) e escuro (Moon/Night)
# =============================================================================
#
#  Acionado por: <prefix> + b
#
#  COMPORTAMENTO
#  ─────────────
#  • Lê a variável tmux @theme_variant para saber o estado atual.
#  • Se "day"  → troca para Moon (escuro) e ativa Dark Mode no macOS.
#  • Caso contrário → troca para Day (claro) e desativa Dark Mode no macOS.
#
#  O toggle de aparência do macOS requer que o processo tenha permissão
#  de acessibilidade. Remova as linhas osascript se não usar macOS
#  ou se preferir controlar o Dark Mode manualmente.
#
#  DEPENDÊNCIAS: tmux, osascript (macOS — opcional)

set -euo pipefail

SCRIPTS_DIR="$(dirname "$0")"

current=$(tmux show -gv @theme_variant 2>/dev/null || echo "moon")

if [[ "$current" == "day" ]]; then
    "$SCRIPTS_DIR/theme-tokyonight-moon.sh"
    # macOS: ativa Dark Mode
    osascript -e 'tell application "System Events" \
        to tell appearance preferences to set dark mode to true' 2>/dev/null || true
else
    "$SCRIPTS_DIR/theme-tokyonight-day.sh"
    # macOS: desativa Dark Mode
    osascript -e 'tell application "System Events" \
        to tell appearance preferences to set dark mode to false' 2>/dev/null || true
fi
