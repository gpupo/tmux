#!/usr/bin/env bash
# =============================================================================
#  theme-tokyonight-moon.sh — Aplica a paleta TokyoNight "Moon/Night" (escuro)
# =============================================================================
#
#  Chamado por theme-toggle.sh ou diretamente.
#  Atualiza as variáveis de cor em tempo real — sem reiniciar o tmux.
#
#  Paleta de referência: https://github.com/folke/tokyonight.nvim
#  Variante: "moon" (usada também como "night")

tmux set -g @theme_variant "moon"

# Fundo escuro azul-carvão
tmux set -g @blue   "#24283b"
# Azul médio para separadores e textos secundários
tmux set -g @blue2  "#525c7d"
# Azul vivo para janela ativa e bordas de destaque
tmux set -g @blue3  "#7aa2f7"
# Verde suave (confirmações, sessão ativa)
tmux set -g @green  "#9ece6a"
# Roxo (hostname)
tmux set -g @purple "#9d7cd8"
# Vermelho/rosa (hora, alertas, bordas)
tmux set -g @red    "#f7768e"
# Amarelo/âmbar (avisos de atividade)
tmux set -g @yellow "#e0af68"

# Redesenha imediatamente todos os clientes conectados
tmux refresh-client -S
