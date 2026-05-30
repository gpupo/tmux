# AGENTS — gpupo/tmux

Repositório público de configuração tmux de @gpupo.
URL: https://github.com/gpupo/tmux

## Estrutura

```
tmux.conf          configuração principal (8 seções documentadas)
bin/               scripts auxiliares (todos executáveis, bash ≥ 5)
docs/              documentação e arquivos de referência
scripts/setup.sh   instalação via symlinks
```

## Instalação

```bash
git clone https://github.com/gpupo/tmux ~/.config/tmux
bash ~/.config/tmux/scripts/setup.sh
```

`setup.sh` cria `~/.tmux.conf → ~/.config/tmux/tmux.conf` e garante
permissões em `bin/`. O TPM se auto-instala ao abrir o tmux.

## Remotes

| Nome | URL | Uso |
|---|---|---|
| `origin` | `ssh://git@git.homelab.gpupo.com/gpupo/gpupo-tmux-config.git` | push contínuo |
| `github` | `git@github.com:gpupo/tmux.git` | push ocasional |

## Caminhos críticos

Os scripts em `bin/` são referenciados no `tmux.conf` como
`$HOME/.config/tmux/bin/<script>`. Não renomear sem atualizar o conf.

O help exibido por `C-g ?` vem de `docs/help.md` via `glow`.
O banner de início rápido está em `docs/banner.md`.

## Scripts notáveis

| Script | Observação |
|---|---|
| `tool-window.sh` | Log opt-in via `TOOL_WINDOW_DEBUG=1` |
| `sessionize` | Histórico em `~/.local/share/tmux-sessionizer/history` |
| `sessionize-host.sh` | Config customizada em `~/.config/tmux-ssh-session/hosts` |
| `cht` | Requer `~/.config/tmux/.tmux-cht-languages` e `.tmux-cht-command` — ver exemplos em `docs/` |
| `theme-toggle.sh` | Chama scripts de tema via `$SCRIPTS_DIR` relativo; usa `osascript` no macOS |

## Convenções

- Bash `set -euo pipefail` em todos os scripts
- Logs em `~/.local/state/` (XDG), nunca no repo
- Caminhos com `$HOME` explícito, nunca `~` em scripts
