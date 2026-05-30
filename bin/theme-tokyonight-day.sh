#!/usr/bin/env bash
# =============================================================================
#  theme-tokyonight-day.sh — Aplica a paleta TokyoNight "Day" (claro)
# =============================================================================
#
#  Chamado por theme-toggle.sh ou diretamente.
#  Atualiza as variáveis de cor em tempo real — sem reiniciar o tmux.
#
#  Paleta de referência: https://github.com/folke/tokyonight.nvim
#  Variante: "day"

tmux set -g @theme_variant "day"

# Fundo claro / branco-azulado
tmux set -g @blue   "#e1e2e7"
# Azul suave para elementos secundários
tmux set -g @blue2  "#c0caf5"
# Azul vivo para elementos ativos e destaques
tmux set -g @blue3  "#2e7de9"
# Verde sóbrio (confirmações, sessão ativa)
tmux set -g @green  "#587539"
# Roxo (hostname, informações secundárias)
tmux set -g @purple "#7847bd"
# Vermelho/rosa (hora, alertas, bordas)
tmux set -g @red    "#f52a65"
# Amarelo/âmbar (avisos de atividade)
tmux set -g @yellow "#8c6c3e"

# Redesenha imediatamente todos os clientes conectados
tmux refresh-client -S
