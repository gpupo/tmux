# TMUX — Início rápido

## Status bar

| Indicador | Significado |
|---|---|
| `TMUX` | Modo normal |
| `WAIT` | Prefix pressionado |
| `COPY` | Modo de cópia vi |
| `SYNC` | Painéis sincronizados |
| `⚑` | Atividade em janela em background |

## Modos

### `C-s` — Sessions

| Tecla | Ação |
|---|---|
| `f` | Fuzzy finder de sessões |
| `l` | Árvore de sessões/janelas |
| `d` | Sessionize `~/.dotfiles/` |
| `k` | Matar sessões em background |
| `r` / `R` | Renomear janela / sessão |
| `Enter` | Toggle popup `~/work/` |

### Presets — `C-s` +

| Tecla | Preset | Janelas |
|---|---|---|
| `a` | **dev** | Terminal · Agent · LazyGit · Nvim |
| `b` | **ops** | Monitor (htop+logs) · Docker |
| `A` | **ai** | Nvim · Claude · Gemini · Codex |
| `e` | **explore** | Yazi+htop · LazyGit |

### `C-g` — Tools

| Tecla | Janela | Comando |
|---|---|---|
| `g` | LazyGit | `lazygit` |
| `d` | LazyDocker | `lazydocker` |
| `n` | Nvim | `nvim` |
| `f` | Yazi | `yazi` |
| `?` | — | este help |

> Tools reutilizam janelas existentes — não duplicam.
> O preset **dev** cria janelas com os mesmos nomes,
> então `C-g g` navega até a janela já aberta.

## Dica

Use **presets** para montar o ambiente de uma vez.
Use **tools** para abrir/navegar ferramentas sob demanda.
