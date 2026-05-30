#!/usr/bin/env bash
# =============================================================================
#  sessionize-host.sh — Gerenciador de sessões tmux para conexões SSH
# =============================================================================
#
#  Uso: sessionize-host.sh [host]
#        Se `host` for fornecido, cria/conecta direto sem o fzf.
#
#  FONTES DE HOSTS (por ordem no fzf)
#  ───────────────────────────────────
#  [recent]  Hosts acessados recentemente (histórico local)
#  [hosts]   ~/.ssh/config + arquivo de hosts customizado
#
#  ARQUIVO DE HOSTS CUSTOMIZADO
#  ────────────────────────────
#  Adicione hosts (um por linha, # para comentários) em:
#    $XDG_CONFIG_HOME/tmux-ssh-session/hosts
#    (padrão: ~/.config/tmux-ssh-session/hosts)
#
#  HISTÓRICO
#  ─────────
#  Cada host acessado é salvo em:
#    $XDG_DATA_HOME/tmux-ssh-session/history
#    (padrão: ~/.local/share/tmux-ssh-session/history)
#
#  NOME DE SESSÃO
#  ──────────────
#  O padrão é  ssh-<host>  (pontos e @ viram _).
#  Exemplo: ssh user@server.local → sessão "ssh-user_server_local"
#
#  DEPENDÊNCIAS: tmux, fzf, ssh

HISTORY_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/tmux-ssh-session/history"
HOSTS_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/tmux-ssh-session/hosts"

mkdir -p "$(dirname "$HISTORY_FILE")"
mkdir -p "$(dirname "$HOSTS_FILE")"
touch "$HISTORY_FILE"
touch "$HOSTS_FILE"

# ── Helpers ───────────────────────────────────────────────────────────────

# Extrai hosts do ~/.ssh/config (ignora wildcards * ? !)
ssh_config_hosts() {
    [[ -f "$HOME/.ssh/config" ]] || return
    grep -iE "^Host " "$HOME/.ssh/config" \
        | awk '{for(i=2;i<=NF;i++) print $i}' \
        | grep -v '[*?!]'
}

# Lista nomes de sessões SSH ativas no tmux (padrão: ssh-<host>)
active_ssh_sessions() {
    tmux list-sessions -F "#{session_name}" 2>/dev/null \
        | grep "^ssh[-_]" \
        | sed 's/^ssh[-_]//'
}

# Salva host no histórico (mantém últimas 200 entradas)
log_host() {
    echo "$1" >> "$HISTORY_FILE"
    tail -200 "$HISTORY_FILE" > "${HISTORY_FILE}.tmp" \
        && mv "${HISTORY_FILE}.tmp" "$HISTORY_FILE"
}

# ── Montar lista para o fzf ───────────────────────────────────────────────

ACTIVE=$(active_ssh_sessions)

# [recent] — últimos 5 hosts sem sessão ativa
recent_inactive=$(
    tac "$HISTORY_FILE" \
    | awk '!seen[$0]++' \
    | while IFS= read -r host; do
        [[ -z "$host" ]] && continue
        echo "$ACTIVE" | grep -qxF "$host" && continue
        echo "$host"
    done \
    | head -5
)

# [hosts] — ssh/config + arquivo customizado (sem duplicatas)
static_hosts=$(
    {
        ssh_config_hosts
        grep -v "^[[:space:]]*#" "$HOSTS_FILE" 2>/dev/null \
            | grep -v "^[[:space:]]*$"
    } | sort -u
)

# Labels coloridos para o fzf
labeled_recent=$(
    echo "$recent_inactive" | grep -v "^$" \
    | awk '{printf "  \033[1;33m[recent]\033[0m  %s\n", $0}'
)

labeled_static=$(
    comm -23 \
        <(echo "$static_hosts" | sort -u) \
        <({ echo "$recent_inactive"; echo "$ACTIVE"; } | grep -v "^$" | sort -u) \
    | awk '{printf "  \033[0;34m[hosts]\033[0m   %s\n", $0}'
)

combined=$(printf "%s\n%s" "$labeled_recent" "$labeled_static" | grep -v "^$")

# ── Seleção via fzf ───────────────────────────────────────────────────────
# --print-query permite digitar um host novo não presente na lista

if [[ $# -eq 1 ]]; then
    selected="$1"
else
    fzf_out=$(
        echo "$combined" \
        | fzf --ansi \
              --reverse \
              --no-sort \
              --prompt "  ssh » " \
              --header $' \033[1m[recent]\033[0m = usados recentemente  |  \033[0;34m[hosts]\033[0m = ssh/config + lista customizada\n Digite um host para conectar diretamente\n' \
              --height 60% \
              --print-query
    )

    lines=$(echo "$fzf_out" | grep -c ".")
    if [[ $lines -ge 2 ]]; then
        # Item selecionado da lista → último campo (sem label colorido)
        selected=$(echo "$fzf_out" | tail -1 | awk '{print $NF}')
    else
        # Host digitado manualmente
        selected=$(echo "$fzf_out" | head -1 | tr -d '[:space:]')
    fi
fi

[[ -z "$selected" ]] && exit 0

# ── Criar / conectar sessão tmux ──────────────────────────────────────────

log_host "$selected"

# Nome de sessão: ssh-<host> com pontos, @ e : substituídos por _
session_name="ssh-$(echo "$selected" | tr '.@:' '_')"

if ! tmux has-session -t="$session_name" 2>/dev/null; then
    tmux new-session -ds "$session_name"
    tmux send-keys -t "$session_name" "ssh $selected" Enter
fi

if [[ -z "${TMUX:-}" ]]; then
    tmux attach -t "$session_name"
else
    tmux switch-client -t "$session_name"
fi
