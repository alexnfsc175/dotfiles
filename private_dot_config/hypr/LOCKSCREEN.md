# Lockscreen & Wallpaper — Guia de Configuração

## Visão Geral

O sistema de lockscreen e wallpaper é composto por:

| Componente | Função | Arquivo de Config |
|-----------|--------|-------------------|
| **hyprlock** | Trava a tela | `hyprlock.conf` → presets em `hyprlock/presets/` |
| **hypridle** | Detecta inatividade | `hypridle.conf` |
| **awww** | Wallpaper estático/GIF (padrão) | — |
| **NeoWall** | Wallpaper shader GLSL (opcional) | `~/.config/neowall/config.vibe` |

### Fluxo de Eventos

```
Inatividade → 10 min → hyprlock trava (screenshot + blur)
           → 11 min → DPMS desliga monitores
           → mouse/teclado → monitores ligam → lockscreen
           → senha → desktop desbloqueado
```

---

## Presets do Hyprlock

O arquivo `hyprlock.conf` carrega um preset via `source =`. Para trocar:

```bash
# Listar presets disponíveis
~/.config/hypr/scripts/lockscreen-preset.sh --list

# Trocar preset
~/.config/hypr/scripts/lockscreen-preset.sh blur       # screenshot + blur (padrão)
~/.config/hypr/scripts/lockscreen-preset.sh slideshow   # wallpapers rotativos
~/.config/hypr/scripts/lockscreen-preset.sh cat-1       # preset original cat-1
~/.config/hypr/scripts/lockscreen-preset.sh cat-2       # preset original cat-2

# Testar lockscreen
hyprlock --immediate
```

### Presets Disponíveis

| Preset | Background | GPU | Descrição |
|--------|-----------|-----|-----------|
| `blur` ✅ | `screenshot` + blur | Baixa | Desfoca a tela atual (padrão) |
| `slideshow` | Wallpapers rotativos | Baixa | Troca imagem a cada 10s |
| `cat-1` | Imagem estática | Mínima | Preset original com gato |
| `cat-2` | ~~`wall.set`~~ | ⚠️ | **Quebrado** — `wall.set` não existe |

### Slideshow

Para usar o preset `slideshow`, adicione imagens em:
```
~/.config/hypr/hyprlock/wallpapers/
```
Formatos aceitos: `.png`, `.jpg`, `.webp`

---

## Wallpaper Animado (NeoWall + Shaders GLSL)

### Instalação

```bash
yay -S neowall-git
```

### Uso

```bash
# Ver status atual
~/.config/hypr/scripts/wallpaper-mode.sh --status

# Ativar shader GLSL (built-in do NeoWall)
~/.config/hypr/scripts/wallpaper-mode.sh neowall plasma
~/.config/hypr/scripts/wallpaper-mode.sh neowall aurora
~/.config/hypr/scripts/wallpaper-mode.sh neowall matrix_rain
~/.config/hypr/scripts/wallpaper-mode.sh neowall retro_wave

# Ativar shader customizado
~/.config/hypr/scripts/wallpaper-mode.sh neowall waves

# Voltar para awww (wallpaper normal)
~/.config/hypr/scripts/wallpaper-mode.sh awww

# Listar todos os shaders
~/.config/hypr/scripts/wallpaper-mode.sh --list-shaders

# Controles NeoWall (quando ativo)
neowall next       # próximo shader
neowall pause      # pausar
neowall resume     # retomar
neowall current    # shader atual
```

### Shaders

NeoWall busca shaders em duas localizações:

| Local | Tipo | Quantidade |
|-------|------|------------|
| `/usr/share/neowall/shaders/` | Built-in | 30+ |
| `~/.config/neowall/shaders/` | Customizado | 3 (Catppuccin) |

**Shaders built-in populares:** `plasma`, `aurora`, `matrix_rain`, `retro_wave`, `synthwave`, `moon_ocean`, `fractal_land`, `mandelbrot`, `star_next`

**Shaders customizados incluídos:**

| Shader | Efeito | GPU |
|--------|--------|-----|
| `waves` | Ondas suaves com brilho | ~1-2% |
| `plasma` (custom) | Plasma com paleta Catppuccin | ~2% |
| `aurora` (custom) | Aurora boreal dark | ~3% |

### Como Funciona com o Lockscreen

Quando o NeoWall está ativo e o hyprlock trava a tela:
1. hyprlock captura a tela via `path = screenshot` (que mostra o shader)
2. Aplica blur sobre o shader capturado
3. Resultado: lockscreen com blur do shader animado

### Adicionar Shaders do Shadertoy

1. Acesse [shadertoy.com](https://shadertoy.com)
2. Copie o código GLSL do shader
3. Salve em `~/.config/neowall/shaders/nomedoshader.glsl`
4. Teste: `~/.config/hypr/scripts/wallpaper-mode.sh neowall nomedoshader`

> **Nota:** NeoWall é compatível com formato Shadertoy.
> O formato básico é ter `void mainImage(out vec4, in vec2)` e `void main()`.

### Configuração Direta (sem script)

O NeoWall usa `~/.config/neowall/config.vibe`:

```
# Shader em todos os monitores
default {
    shader retro_wave.glsl
    shader_speed 0.8
}

# Shader por monitor
output {
    eDP-1 {
        shader aurora.glsl
    }
    HDMI-A-1 {
        shader matrix_rain.glsl
    }
    DP-2 {
        shader plasma.glsl
    }
}
```

---

## DPMS (Desligar Monitores)

Configurado em `hypridle.conf`:

| Timeout | Ação |
|---------|------|
| 10 min | `loginctl lock-session` → hyprlock ativa |
| 11 min | `hyprctl dispatch dpms off` → monitores desligam |
| Mouse/teclado | `hyprctl dispatch dpms on` → monitores ligam |

Para alterar os timeouts, edite com:
```bash
chezmoi edit ~/.config/hypr/hypridle.conf
```

---

## Estrutura de Arquivos

```
~/.config/hypr/
├── hyprlock.conf              # Carrega preset via source=
├── hypridle.conf              # Timeouts de inatividade + DPMS
├── LOCKSCREEN.md              # Este documento
├── hyprlock/
│   ├── presets/
│   │   ├── blur.conf          # ✅ Default — screenshot + blur
│   │   ├── slideshow.conf     # Wallpapers rotativos
│   │   ├── cat-1.conf         # Preset original
│   │   └── cat-2.conf         # ⚠️ Quebrado (wall.set inexistente)
│   ├── wallpapers/            # Imagens para o preset slideshow
│   └── *.png                  # Imagens usadas nos presets
├── shaders/                   # Cópia dos shaders (backup)
│   ├── plasma.glsl
│   ├── aurora.glsl
│   └── waves.glsl
└── scripts/
    ├── lockscreen-preset.sh   # Troca presets do hyprlock
    └── wallpaper-mode.sh      # Alterna awww ↔ NeoWall

~/.config/neowall/             # Config do NeoWall
├── config.vibe                # Gerado por wallpaper-mode.sh
└── shaders/                   # Shaders customizados
    ├── plasma.glsl
    ├── aurora.glsl
    └── waves.glsl
```

---

## Rollback

```bash
# Reverter último commit do chezmoi
chezmoi git -- revert HEAD
chezmoi apply

# Reverter múltiplos commits
chezmoi git -- log --oneline -6   # ver commits
chezmoi git -- revert <hash>      # reverter commit específico
chezmoi apply

# Reset total para origin/main
chezmoi git -- reset --hard origin/main
chezmoi apply
```

---

## Troubleshooting

| Problema | Solução |
|----------|---------|
| Tela branca no lock | Verificar que preset é `blur`, não `cat-2` |
| Widgets só em 1 monitor | Verificar `monitor =` (vazio) no preset |
| NeoWall não inicia | `yay -S neowall-git` e verificar GPU drivers |
| NeoWall `--shader` erro | Usar `wallpaper-mode.sh` (gera config.vibe) |
| awww não restaura | `awww-daemon &` e depois `awww restore` |
| DPMS não desliga | Verificar `hypridle.conf` timeout correto |
| Shader com erro | Verificar formato GLSL (precisa de `void main()`) |
