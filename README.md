# tmux config — @gpupo

Configuração pessoal do tmux com foco em fluxo de trabalho centrado em teclado,
tema **TokyoNight** e dois modos customizados de navegação.

## Filosofia

- Tudo acessível pelo teclado, inspirado no Vim
- **`C-s`** — modo *Sessions*: gerenciar e navegar sessões
- **`C-g`** — modo *Tools*: abrir ferramentas TUI dedicadas
- Plugins mínimos, scripts transparentes, fácil de customizar

## Requisitos

| Dependência | Obrigatório | Papel |
|---|---|---|
| [tmux](https://github.com/tmux/tmux) ≥ 3.4 | ✅ | — |
| [TPM](https://github.com/tmux-plugins/tpm) | ✅ | gerenciador de plugins (auto-instalado) |
| [bash](https://www.gnu.org/software/bash/) ≥ 5 | ✅ | scripts em `bin/` |
| [fzf](https://github.com/junegunn/fzf) | ✅ | seleção interativa |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | recomendado | diretórios frequentes no sessionize |
| [tms](https://github.com/jrmoulton/tmux-sessionizer) | opcional | fuzzy finder de sessões alternativo |
| [glow](https://github.com/charmbracelet/glow) | opcional | renderiza o help (`C-g ?`) |
| lazygit, lazydocker, nvim, yazi | opcional | ferramentas do modo Tools |

## Instalação

```bash
git clone https://github.com/gpupo/tmux ~/.config/tmux
bash ~/.config/tmux/scripts/setup.sh
```

O `setup.sh`:
1. Cria `~/.tmux.conf` → `~/.config/tmux/tmux.conf`
2. Marca os scripts em `bin/` como executáveis
3. Oferece instalar o TPM (ou ele se auto-instala ao abrir o tmux)

Depois, dentro do tmux:

```
<prefix> + I   instala os plugins via TPM
<prefix> + r   recarrega o tmux.conf
```

## Atalhos

### Modos customizados

#### `C-s` — Sessions

| Tecla | Ação |
|---|---|
| `f` | Fuzzy finder de sessões |
| `l` | Árvore de sessões/janelas |
| `d` | Sessionize `~/.dotfiles/` |
| `k` | Matar sessões em background |
| `r` / `R` | Renomear janela / sessão |
| `Enter` | Toggle popup `~/work/` |
| `a` | Preset **dev** |
| `b` | Preset **ops** |
| `A` | Preset **ai** |
| `e` | Preset **explore** |

#### `C-g` — Tools

| Tecla | Janela | Comando |
|---|---|---|
| `g` | LazyGit | `lazygit` |
| `d` | LazyDocker | `lazydocker` |
| `n` | Nvim | `nvim` |
| `f` | Yazi | `yazi` |
| `?` | — | help via `glow` |

> Janelas são **reutilizadas** pelo nome — não há duplicatas.
> Os presets criam janelas com os mesmos nomes, então `C-g g` encontra
> a janela LazyGit aberta pelo preset `dev`.

### Globais (sem prefix)

| Tecla | Ação |
|---|---|
| `C-h` / `C-l` | Janela anterior / próxima |
| `C-j` / `C-k` | Sessão próxima / anterior |
| `Shift+PgUp` | Modo de cópia (scroll) |
| `Alt+V` | Carrega clipboard macOS no buffer |

### Com prefix (`C-b`)

| Tecla | Ação |
|---|---|
| `h/j/k/l` | Navegar entre painéis |
| `r` | Recarregar `tmux.conf` |
| `b` | Alternar tema claro ↔ escuro |
| `,` | Editar `tmux.conf` no Neovim |
| `Enter` | Popup rápido |

## Presets de layout

Acionados via `C-s` + letra. Cada preset monta janelas e painéis
a partir do diretório atual, de forma **idempotente**.

| Preset | Janelas |
|---|---|
| **dev** | Terminal · Agent · LazyGit · Nvim |
| **ops** | Monitor (htop + logs) · Docker |
| **ai** | Nvim · Claude · Gemini · Codex |
| **explore** | Yazi + htop · LazyGit |

## Tema: TokyoNight

Paleta Night (escuro) por padrão. Alterne com `<prefix> + b`.

| Variável | Cor | Uso |
|---|---|---|
| `@blue` | `#24283b` | fundo da UI |
| `@blue2` | `#525c7d` | separadores, textos secundários |
| `@blue3` | `#7aa2f7` | janela ativa, bordas |
| `@green` | `#9ece6a` | sessão ativa, confirmações |
| `@purple` | `#9d7cd8` | hostname |
| `@red` | `#f7768e` | hora, alertas, bordas de menus |
| `@yellow` | `#e0af68` | avisos de atividade |

No macOS o toggle também sincroniza o Dark Mode do sistema via `osascript`.

## Scripts (`bin/`)

| Script | Descrição |
|---|---|
| `sessionize` | Fuzzy finder de sessões com zoxide + histórico |
| `sessionize-host.sh` | Sessões SSH via `~/.ssh/config` + lista customizada |
| `tool-window.sh` | Abre ou reutiliza janela por ferramenta |
| `presets.sh` | Layouts pré-configurados |
| `popup-toggle.sh` | Popup persistente `~/work/` |
| `theme-toggle.sh` | Alterna tema claro/escuro |
| `theme-tokyonight-day.sh` | Aplica paleta Day |
| `theme-tokyonight-moon.sh` | Aplica paleta Moon/Night |
| `kill-session` | Mata sessões em background |
| `list-agents` | Abre agente de IA escolhido via fzf |
| `cht` | Cheatsheet interativo via cht.sh |

## Plugins

| Plugin | Função |
|---|---|
| [tpm](https://github.com/tmux-plugins/tpm) | Gerenciador de plugins |
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Defaults sensatos |
| [tmux-prefix-highlight](https://github.com/tmux-plugins/tmux-prefix-highlight) | Destaque do prefix na status bar |
| [tmux-mode-indicator](https://github.com/MunifTanjim/tmux-mode-indicator) | Indicador de modo (TMUX/WAIT/COPY/SYNC) |
| [tmux-notify](https://github.com/rickstaa/tmux-notify) | Notificação quando comando termina |

## Estrutura

```
.
├── tmux.conf            # configuração principal
├── bin/                 # scripts auxiliares
├── docs/
│   └── help.md          # referência de atalhos (C-g ?)
└── scripts/
    └── setup.sh         # instalação
```

## Licença

MIT
