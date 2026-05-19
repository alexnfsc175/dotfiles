# 🎹 Documentação de Atalhos de Teclado — Hyprland

> Referência completa dos atalhos definidos em `config/binds.conf`.
> **Tecla principal (mainMod):** `SUPER` (tecla ⊞ Windows / ⌘ Command)

---

## 📖 Índice

1. [Como Funciona a Sintaxe dos Binds](#-como-funciona-a-sintaxe-dos-binds)
2. [Variáveis Globais](#-variáveis-globais)
3. [Aplicativos](#-aplicativos)
4. [Display / Zoom](#-display--zoom)
5. [Gerenciamento de Janelas](#-gerenciamento-de-janelas)
6. [Ações e Utilitários](#-ações-e-utilitários)
7. [Workspaces (Áreas de Trabalho)](#-workspaces-áreas-de-trabalho)
8. [Teclas de Função (Fn)](#-teclas-de-função-fn)
9. [Tabela Resumida de Todos os Atalhos](#-tabela-resumida-de-todos-os-atalhos)

---

## 🔧 Como Funciona a Sintaxe dos Binds

O Hyprland usa diferentes tipos de bind, cada um com um comportamento específico:

| Tipo | Descrição |
|------|-----------|
| `bind` | Atalho padrão — dispara uma vez ao pressionar as teclas. |
| `binde` | Atalho com **repeat** — continua disparando enquanto as teclas estiverem pressionadas. |
| `bindle` | Atalho com **repeat** e que também funciona com a tela **bloqueada**. |
| `bindm` | Atalho de **mouse** — vincula uma ação ao clique do mouse junto com modificadores. |

### Formato geral

```
bind = MODIFICADORES, TECLA, DISPATCHER, ARGUMENTOS
```

- **MODIFICADORES**: combinação de teclas como `SUPER`, `SHIFT`, `CTRL`, `ALT`.
- **TECLA**: a tecla que ativa o atalho (ex: `RETURN`, `B`, `1`, `mouse_down`).
- **DISPATCHER**: a ação do Hyprland a executar (ex: `exec`, `workspace`, `killactive`).
- **ARGUMENTOS**: parâmetros passados ao dispatcher (ex: nome do programa, número do workspace).

---

## 📌 Variáveis Globais

Variáveis definidas no início do arquivo e reutilizadas nos binds:

| Variável | Valor | Descrição |
|----------|-------|-----------|
| `$mainMod` | `SUPER` | Tecla modificadora principal |
| `$HYPRSCRIPTS` | `~/.config/hypr/scripts` | Diretório de scripts do Hyprland |
| `$ROFI_SCRIPTS` | `~/.config/rofi/scripts` | Diretório de scripts do Rofi |

> Os aplicativos padrão (`$terminal`, `$browser`, `$fileManager`, `$menu`) são importados de `~/.config/hypr/config/default_apps.conf`.

---

## 🚀 Aplicativos

Atalhos para abrir aplicativos do dia a dia.

| Atalho | Ação |
|--------|------|
| `SUPER + Enter` | Abre o **terminal** padrão |
| `SUPER + B` | Abre o **navegador** padrão |
| `SUPER + E` | Abre o **gerenciador de arquivos** |
| `SUPER + CTRL + E` | Abre o seletor de **emojis** (Rofi) |

### Como usar

- Pressione e solte `SUPER + Enter` para abrir uma nova janela de terminal.
- Use `SUPER + CTRL + E` para inserir rapidamente um emoji — o picker do Rofi vai aparecer e basta digitar para filtrar.

---

## 🔍 Display / Zoom

Atalhos para controlar o zoom da tela usando o cursor.

| Atalho | Ação |
|--------|------|
| `SUPER + SHIFT + Scroll Down` | **Aumenta** o zoom do display em 0.5x |
| `SUPER + SHIFT + Scroll Up` | **Diminui** o zoom do display em 0.5x |
| `SUPER + SHIFT + Z` | **Reseta** o zoom para 1x (normal) |

### Como usar

- Segure `SUPER + SHIFT` e role a **roda do mouse para baixo** para dar zoom in.
- Para voltar ao normal rapidamente, pressione `SUPER + SHIFT + Z`.

---

## 🪟 Gerenciamento de Janelas

### Fechar e Controlar Janelas

| Atalho | Ação |
|--------|------|
| `SUPER + Q` | **Fecha** a janela ativa |
| `SUPER + SHIFT + Q` | **Mata o processo** da janela ativa (fecha todas as instâncias) |
| `SUPER + F` | Alterna a janela ativa para **tela cheia** (fullscreen) |
| `SUPER + M` | **Maximiza** a janela ativa (mantém barra/gaps visíveis) |
| `SUPER + T` | Alterna a janela ativa entre modo **flutuante** e tiled |
| `SUPER + SHIFT + T` | Alterna **todas** as janelas do workspace para flutuante |
| `SUPER + J` | Alterna o **split** (divisão horizontal/vertical) |
| `SUPER + K` | **Troca o split** (swap split) |
| `SUPER + G` | Alterna **grupo de janelas** (tabs) |

> **Diferença entre `Q` e `SHIFT + Q`:**
> - `SUPER + Q` envia um sinal de fechar apenas para a janela ativa.
> - `SUPER + SHIFT + Q` mata o processo inteiro (PID), fechando todas as janelas daquele programa.

### Mover o Foco

| Atalho | Ação |
|--------|------|
| `SUPER + ←` | Move o foco para a **esquerda** |
| `SUPER + →` | Move o foco para a **direita** |
| `SUPER + ↑` | Move o foco para **cima** |
| `SUPER + ↓` | Move o foco para **baixo** |
| `ALT + Tab` | **Cicla** entre as janelas abertas |

### Mover Janelas com o Mouse

| Atalho | Ação |
|--------|------|
| `SUPER + Clique Esquerdo (arrastar)` | **Move** a janela pela tela |
| `SUPER + Clique Direito (arrastar)` | **Redimensiona** a janela |

### Redimensionar Janelas com o Teclado

| Atalho | Ação |
|--------|------|
| `SUPER + SHIFT + →` | Aumenta a **largura** em 100px |
| `SUPER + SHIFT + ←` | Diminui a **largura** em 100px |
| `SUPER + SHIFT + ↓` | Aumenta a **altura** em 100px |
| `SUPER + SHIFT + ↑` | Diminui a **altura** em 100px |

### Trocar Posição de Janelas (Swap)

| Atalho | Ação |
|--------|------|
| `SUPER + ALT + ←` | Troca a janela tiled com a da **esquerda** |
| `SUPER + ALT + →` | Troca a janela tiled com a da **direita** |
| `SUPER + ALT + ↑` | Troca a janela tiled com a de **cima** |
| `SUPER + ALT + ↓` | Troca a janela tiled com a de **baixo** |

---

## ⚡ Ações e Utilitários

| Atalho | Ação |
|--------|------|
| `SUPER + CTRL + R` | **Recarrega** a configuração do Hyprland |
| `SUPER + SHIFT + A` | Alterna as **animações** on/off |
| `SUPER + SHIFT + S` | Abre o menu de **captura de tela** (screenshot via Rofi) |
| `SUPER + CTRL + Q` | Abre o **menu de energia** (desligar, reiniciar, suspender, etc.) |
| `SUPER + SHIFT + W` | **Troca o wallpaper** (mantendo o mesmo estilo) |
| `SUPER + CTRL + Enter` | Abre o **lançador de aplicativos** (Rofi/menu) |
| `SUPER + V` | Abre o **gerenciador de clipboard** (histórico da área de transferência) |

### Como usar

- **Recarregar config:** Após editar qualquer arquivo `.conf` do Hyprland, pressione `SUPER + CTRL + R` para aplicar sem reiniciar a sessão.
- **Screenshot:** `SUPER + SHIFT + S` abre um menu Rofi com opções de captura (tela inteira, região, janela, etc.).
- **Clipboard:** `SUPER + V` mostra o histórico do clipboard para colar itens anteriores.

---

## 🖥️ Workspaces (Áreas de Trabalho)

O Hyprland suporta 10 workspaces numerados de 1 a 10.

### Navegar entre Workspaces

| Atalho | Ação |
|--------|------|
| `SUPER + 1` a `SUPER + 0` | Vai para o workspace **1** a **10** |
| `SUPER + Tab` | Vai para o **próximo** workspace |
| `SUPER + SHIFT + Tab` | Vai para o workspace **anterior** |
| `SUPER + Scroll Down` | Vai para o próximo workspace (mouse) |
| `SUPER + Scroll Up` | Vai para o workspace anterior (mouse) |
| `SUPER + CTRL + ↓` | Vai para o próximo workspace **vazio** |

### Mover Janela para Workspace

| Atalho | Ação |
|--------|------|
| `SUPER + SHIFT + 1` a `SUPER + SHIFT + 0` | Move a janela ativa para o workspace **1** a **10** |

### Mover TODAS as Janelas para Workspace

| Atalho | Ação |
|--------|------|
| `SUPER + CTRL + 1` a `SUPER + CTRL + 0` | Move **todas** as janelas para o workspace **1** a **10** |

### Como usar

- Para organizar seu fluxo de trabalho, use workspaces separados: ex. **1** para terminal, **2** para navegador, **3** para editor.
- Use `SUPER + SHIFT + número` para enviar rapidamente uma janela para outro workspace.
- `SUPER + Tab` permite navegar sequencialmente sem lembrar o número.

---

## 🎛️ Teclas de Função (Fn)

Atalhos para as teclas especiais do teclado (geralmente no topo de laptops).

### Brilho da Tela

| Atalho | Ação |
|--------|------|
| `Fn + Brilho ↑` (`XF86MonBrightnessUp`) | Aumenta brilho em **10%** |
| `Fn + Brilho ↓` (`XF86MonBrightnessDown`) | Diminui brilho em **10%** |

### Volume de Áudio

| Atalho | Ação |
|--------|------|
| `Fn + Volume ↑` (`XF86AudioRaiseVolume`) | Aumenta volume em **5%** (máx 100%) |
| `Fn + Volume ↓` (`XF86AudioLowerVolume`) | Diminui volume em **5%** |
| `Fn + Mute` (`XF86AudioMute`) | Alterna **mudo** (áudio) |
| `Fn + Mic Mute` (`XF86AudioMicMute`) | Alterna **mudo** (microfone) |

> **Nota:** Os atalhos de volume usam `bindle`, ou seja, funcionam mesmo com a tela **bloqueada** e repetem ao manter pressionado.

### Controle de Mídia

| Atalho | Ação |
|--------|------|
| `Fn + Play` (`XF86AudioPlay`) | **Play/Pause** da mídia atual |
| `Fn + Pause` (`XF86AudioPause`) | **Pause** da mídia |
| `Fn + Next` (`XF86AudioNext`) | Próxima faixa |
| `Fn + Prev` (`XF86AudioPrev`) | Faixa anterior |

### Outros

| Atalho | Ação |
|--------|------|
| `XF86Lock` | Abre o **bloqueio de tela** (hyprlock) |
| `XF86Tools` | Abre as **configurações** do ML4W |
| `code:238` | Aumenta brilho do **teclado** retroiluminado |
| `code:237` | Diminui brilho do **teclado** retroiluminado |

---

## 📋 Tabela Resumida de Todos os Atalhos

| Categoria | Atalho | Ação |
|-----------|--------|------|
| **Apps** | `SUPER + Enter` | Terminal |
| **Apps** | `SUPER + B` | Navegador |
| **Apps** | `SUPER + E` | Gerenciador de Arquivos |
| **Apps** | `SUPER + CTRL + E` | Emoji Picker |
| **Zoom** | `SUPER + SHIFT + Scroll ↓` | Zoom In |
| **Zoom** | `SUPER + SHIFT + Scroll ↑` | Zoom Out |
| **Zoom** | `SUPER + SHIFT + Z` | Reset Zoom |
| **Janelas** | `SUPER + Q` | Fechar janela |
| **Janelas** | `SUPER + SHIFT + Q` | Matar processo |
| **Janelas** | `SUPER + F` | Tela cheia |
| **Janelas** | `SUPER + M` | Maximizar |
| **Janelas** | `SUPER + T` | Flutuante |
| **Janelas** | `SUPER + SHIFT + T` | Todas flutuantes |
| **Janelas** | `SUPER + J` | Toggle split |
| **Janelas** | `SUPER + K` | Swap split |
| **Janelas** | `SUPER + G` | Toggle grupo |
| **Janelas** | `SUPER + Setas` | Mover foco |
| **Janelas** | `SUPER + SHIFT + Setas` | Redimensionar |
| **Janelas** | `SUPER + ALT + Setas` | Trocar posição |
| **Janelas** | `ALT + Tab` | Ciclar janelas |
| **Mouse** | `SUPER + Clique Esq.` | Mover janela |
| **Mouse** | `SUPER + Clique Dir.` | Redimensionar janela |
| **Ações** | `SUPER + CTRL + R` | Recarregar config |
| **Ações** | `SUPER + SHIFT + A` | Toggle animações |
| **Ações** | `SUPER + SHIFT + S` | Screenshot |
| **Ações** | `SUPER + CTRL + Q` | Menu de energia |
| **Ações** | `SUPER + SHIFT + W` | Trocar wallpaper |
| **Ações** | `SUPER + CTRL + Enter` | Launcher |
| **Ações** | `SUPER + V` | Clipboard |
| **Workspace** | `SUPER + 1-0` | Ir para workspace |
| **Workspace** | `SUPER + SHIFT + 1-0` | Mover janela |
| **Workspace** | `SUPER + CTRL + 1-0` | Mover todas |
| **Workspace** | `SUPER + Tab` | Próximo workspace |
| **Workspace** | `SUPER + SHIFT + Tab` | Workspace anterior |
| **Workspace** | `SUPER + CTRL + ↓` | Workspace vazio |
| **Fn** | `Brilho ↑/↓` | Brilho ±10% |
| **Fn** | `Volume ↑/↓` | Volume ±5% |
| **Fn** | `Mute` | Mudo áudio |
| **Fn** | `Mic Mute` | Mudo microfone |
| **Fn** | `Play/Next/Prev` | Controle de mídia |
| **Fn** | `Lock` | Bloquear tela |

---

> **Dica:** Para personalizar qualquer atalho, edite o arquivo `~/.config/hypr/config/binds.conf` e depois recarregue a configuração com `SUPER + CTRL + R`.
