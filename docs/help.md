# TMUX — REFERÊNCIA RÁPIDA DE ATALHOS

> Pressione `<prefix> + ?` para ver esta ajuda dentro do tmux via `glow`.

---

## STATUS BAR

| Indicador | Significado |
|-----------|-------------|
| `TMUX`    | Modo normal |
| `WAIT`    | Prefix pressionado — aguardando próxima tecla |
| `COPY`    | Modo de cópia vi ativo |
| `SYNC`    | Painéis sincronizados (broadcast) |
| `⚑`       | Atividade em janela em segundo plano |

---

## MODO SESSIONS — `Ctrl+S`

Pressione `C-s` para ativar. O label **SESSIONS** aparece na barra.

| Tecla   | Ação |
|---------|------|
| `f`     | Fuzzy finder de sessões (`tms` / sessionize) |
| `l`     | Árvore visual de sessões e janelas |
| `d`     | Sessionize para `~/.dotfiles/` |
| `k`     | Matar todas as sessões exceto a atual |
| `r`     | Renomear janela atual |
| `R`     | Renomear sessão atual |
| `Enter` | Toggle popup persistente (`~/work/`) |
| `C-s`   | Passthrough — envia `C-s` real ao programa |

### Presets de layout

| Tecla | Preset      | Janelas criadas |
|-------|-------------|-----------------|
| `a`   | **dev**     | Terminal · Agent · LazyGit · Nvim |
| `b`   | **ops**     | Monitor (htop+logs) · Docker |
| `A`   | **ai**      | Nvim · Claude · Gemini · Codex |
| `r`   | **read**    | Reader (bat+less) · Files (yazi) |
| `e`   | **explore** | Explore (yazi+htop) · Git |

> Os nomes das janelas dos presets coincidem com os do modo TOOLS,
> então `C-g g` navega diretamente para a janela LazyGit do preset.

---

## MODO TOOLS — `Ctrl+G`

Pressione `C-g` para ativar. O label **TOOLS** aparece na barra.

| Tecla | Janela       | Comando |
|-------|--------------|---------|
| `g`   | LazyGit      | `lazygit` |
| `d`   | LazyDocker   | `lazydocker` |
| `n`   | Nvim         | `nvim` |
| `f`   | Yazi         | `yazi` |
| `?`   | —            | Abre este help via `glow` |
| `C-g` | —            | Passthrough — envia `C-g` real |

> Janelas são **reutilizadas** pelo nome. Não há duplicatas.

---

## ATALHOS GLOBAIS (sem prefix)

| Tecla          | Ação |
|----------------|------|
| `Ctrl+H`       | Janela anterior |
| `Ctrl+L`       | Próxima janela |
| `Ctrl+J`       | Próxima sessão |
| `Ctrl+K`       | Sessão anterior |
| `Shift+PgUp`   | Entra no modo de cópia (scroll up) |
| `Alt+V`        | Carrega clipboard macOS no buffer tmux |
| `Ctrl+Home`    | Volta ao painel do Neovim |

---

## ATALHOS COM PREFIX (`Ctrl+B` por padrão)

| Tecla       | Ação |
|-------------|------|
| `,`         | Editar `~/.tmux.conf` no Neovim |
| `r`         | Recarregar `tmux.conf` |
| `b`         | Alternar tema claro ↔ escuro |
| `Enter`     | Popup rápido (shell 90×40%) |
| `h/j/k/l`  | Navegar entre painéis |
| `^`         | Última janela visitada |
| `[`         | Entrar no modo de cópia |

### Modo de cópia (vi)

| Tecla | Ação |
|-------|------|
| `v`   | Iniciar seleção |
| `y`   | Copiar seleção e sair |
| `q`   | Sair do modo de cópia |
