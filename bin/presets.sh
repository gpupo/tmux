#!/usr/bin/env bash
# =============================================================================
#  presets.sh — Layouts pré-configurados de janelas e painéis
# =============================================================================
#
#  Uso: presets.sh <preset>
#
#  Presets disponíveis:
#   dev      Terminal + Agent + LazyGit + Nvim
#   ops      Monitor (htop) + logs + LazyDocker
#   ai       Nvim + Claude + Gemini + Codex
#   read     Leitor (bat + less) + Yazi
#   explore  Yazi + htop + LazyGit
#
#  Acionado por: C-s → a/b/A/r/e  (modo SESSIONS no tmux.conf)
#
#  COMO FUNCIONA
#  ─────────────
#  1. Captura a sessão e o diretório do painel atual.
#  2. Remove janelas 2, 3, 4 para garantir idempotência
#     (rodar o preset duas vezes não duplica as janelas).
#  3. Cria as janelas/painéis conforme o preset escolhido.
#  4. Volta para a janela 1 ao final.
#
#  COMO CRIAR UM PRESET PERSONALIZADO
#  ────────────────────────────────────
#  Adicione um novo `case` seguindo o padrão dos existentes.
#  Use os helpers new_win, split_v e split_h definidos abaixo.

set -euo pipefail

# ── Descomente para depuração ─────────────────────────────────────────────
# exec >/tmp/tmux-preset.log 2>&1
# set -x

preset="${1:-}"

if [[ -z "$preset" ]]; then
    echo "Uso: presets.sh [dev|ops|ai|read|explore]"
    exit 1
fi

# ── Contexto tmux ─────────────────────────────────────────────────────────
session=$(tmux display-message -p '#S')
path=$(tmux display-message -p '#{pane_current_path}')

# ── Limpeza (idempotência) ────────────────────────────────────────────────
# Remove janelas extras para que o preset sempre produza o mesmo resultado.
tmux kill-window -t "$session:2" 2>/dev/null || true
tmux kill-window -t "$session:3" 2>/dev/null || true
tmux kill-window -t "$session:4" 2>/dev/null || true
tmux kill-pane   -a -t "$session:1" 2>/dev/null || true

# ── Helpers ───────────────────────────────────────────────────────────────

# Cria nova janela com índice, nome e comando inicial opcional
new_win() {
    local idx="$1" name="$2" cmd="$3"
    tmux new-window -t "$session:$idx" -n "$name" -c "$path"
    [[ -n "$cmd" ]] && tmux send-keys -t "$session:$idx" "$cmd" C-m
}

# Divide o painel verticalmente (cima/baixo) e roda comando
split_v() {
    local target="$1" cmd="$2"
    tmux split-window -v -t "$target" -c "$path"
    [[ -n "$cmd" ]] && tmux send-keys -t "$target" "$cmd" C-m
}

# Divide o painel horizontalmente (esquerda/direita) e roda comando
split_h() {
    local target="$1" cmd="$2"
    tmux split-window -h -t "$target" -c "$path"
    [[ -n "$cmd" ]] && tmux send-keys -t "$target" "$cmd" C-m
}

# ── Presets ───────────────────────────────────────────────────────────────
case "$preset" in

dev)
    # Ambiente de desenvolvimento:
    #   1. Terminal  — shell no diretório do projeto
    #   2. Agent     — agente de IA (ex: claude, pi)
    #   3. LazyGit   — interface TUI do Git
    #   4. Nvim      — editor
    #
    # Obs: os nomes LazyGit e Nvim coincidem com os do modo TOOLS (C-g),
    # então C-g g/n navega para as janelas abertas pelo preset.
    tmux rename-window -t "$session:1" "Terminal"
    new_win 2 "Agent"   "ls"
    new_win 3 "LazyGit" "lazygit"
    new_win 4 "Nvim"    "nvim"
    ;;

ops)
    # Ambiente de operações/monitoramento:
    #   1. MONITOR  — htop no painel superior + logs no inferior
    #   2. DOCKER   — LazyDocker
    tmux rename-window -t "$session:1" "MONITOR"
    tmux send-keys -t "$session:1.1" "htop" C-m
    split_v "$session:1" "tail -f *.log 2>/dev/null || clear"
    new_win 2 "DOCKER" "lazydocker"
    ;;

ai)
    # Ambiente multi-agente de IA:
    #   1. Nvim     — editor + contexto
    #   2. Claude   — Claude CLI
    #   3. Gemini   — Gemini CLI
    #   4. Codex    — OpenAI Codex CLI
    tmux rename-window -t "$session:1" "Nvim"
    tmux send-keys -t "$session:1.1" "nvim" C-m
    new_win 2 "Claude" "claude"
    new_win 3 "Gemini" "gemini"
    new_win 4 "Codex"  "codex"
    ;;

read)
    # Ambiente de leitura/exploração de código:
    #   1. READER  — bat (preview) no topo + less no painel inferior
    #   2. FILES   — Yazi (gerenciador de arquivos)
    tmux rename-window -t "$session:1" "READER"
    tmux send-keys -t "$session:1.1" "bat README.md 2>/dev/null || clear" C-m
    split_v "$session:1" "less README.md 2>/dev/null || clear"
    new_win 2 "FILES" "yazi"
    ;;

explore)
    # Ambiente de exploração geral / debugging leve:
    #   1. EXPLORE — Yazi (esquerda) + htop (direita)
    #   2. GIT     — LazyGit
    tmux rename-window -t "$session:1" "EXPLORE"
    tmux send-keys -t "$session:1.1" "yazi" C-m
    split_h "$session:1" "htop"
    new_win 2 "GIT" "lazygit"
    ;;

*)
    echo "Preset desconhecido: $preset"
    echo "Disponíveis: dev | ops | ai | read | explore"
    exit 1
    ;;
esac

# ── Volta para a janela principal ─────────────────────────────────────────
tmux select-window -t "$session:1"
