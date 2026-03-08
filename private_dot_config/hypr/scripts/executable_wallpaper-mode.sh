#!/bin/bash
# wallpaper-mode.sh — Alterna entre awww (wallpaper estático/GIF) e NeoWall (shader GLSL)
#
# Uso:
#   wallpaper-mode.sh awww                  # Volta para awww (wallpaper padrão)
#   wallpaper-mode.sh awww <imagem>         # Volta para awww com wallpaper específico
#   wallpaper-mode.sh neowall <shader>      # Ativa NeoWall com shader GLSL
#   wallpaper-mode.sh neowall               # Ativa NeoWall com shader padrão (plasma)
#   wallpaper-mode.sh --status              # Mostra qual está ativo
#   wallpaper-mode.sh --list-shaders        # Lista shaders disponíveis
#
# Requer: awww-git, neowall-git (yay -S neowall-git)
#
# NeoWall busca shaders em:
#   1. ~/.config/neowall/shaders/    (customizados)
#   2. /usr/share/neowall/shaders/   (built-in, 30+)

NEOWALL_CONFIG_DIR="$HOME/.config/neowall"
NEOWALL_CONFIG="$NEOWALL_CONFIG_DIR/config.vibe"
NEOWALL_CUSTOM_SHADERS="$NEOWALL_CONFIG_DIR/shaders"
NEOWALL_BUILTIN_SHADERS="/usr/share/neowall/shaders"
DEFAULT_SHADER="plasma"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
DIM='\033[2m'
NC='\033[0m'

show_status() {
    if pgrep -x neowall > /dev/null 2>&1; then
        local current
        current=$(neowall current 2>/dev/null || echo "desconhecido")
        echo -e "${CYAN}● NeoWall${NC} (shader GLSL ativo: $current)"
    elif pgrep -x awww-daemon > /dev/null 2>&1 || pgrep -x awww > /dev/null 2>&1; then
        echo -e "${GREEN}● awww${NC} (wallpaper padrão ativo)"
    else
        echo -e "${RED}● Nenhum${NC} daemon de wallpaper ativo"
    fi
}

list_shaders() {
    echo -e "${YELLOW}Shaders disponíveis:${NC}"
    echo ""

    # Built-in
    if [ -d "$NEOWALL_BUILTIN_SHADERS" ]; then
        echo -e "  ${DIM}Built-in ($NEOWALL_BUILTIN_SHADERS):${NC}"
        for shader in "$NEOWALL_BUILTIN_SHADERS"/*.glsl; do
            [ -f "$shader" ] || continue
            local name
            name=$(basename "$shader" .glsl)
            echo -e "    ○ $name"
        done
        echo ""
    fi

    # Customizados
    if [ -d "$NEOWALL_CUSTOM_SHADERS" ] && [ -n "$(ls -A "$NEOWALL_CUSTOM_SHADERS"/*.glsl 2>/dev/null)" ]; then
        echo -e "  ${DIM}Customizados ($NEOWALL_CUSTOM_SHADERS):${NC}"
        for shader in "$NEOWALL_CUSTOM_SHADERS"/*.glsl; do
            [ -f "$shader" ] || continue
            local name
            name=$(basename "$shader" .glsl)
            echo -e "    ${CYAN}★${NC} $name"
        done
        echo ""
    fi

    echo -e "  ${DIM}Dica: Baixe shaders de https://shadertoy.com${NC}"
    echo -e "  ${DIM}Salve em $NEOWALL_CUSTOM_SHADERS/nome.glsl${NC}"
}

# Resolve o nome do shader (com ou sem .glsl)
resolve_shader() {
    local name="$1"
    # Remove .glsl se presente
    name="${name%.glsl}"
    echo "$name"
}

stop_all_daemons() {
    if pgrep -x neowall > /dev/null 2>&1; then
        echo -e "  Parando NeoWall..."
        neowall kill 2>/dev/null
        sleep 0.5
    fi
    if pgrep -x awww-daemon > /dev/null 2>&1 || pgrep -x awww > /dev/null 2>&1; then
        echo -e "  Parando awww..."
        awww kill 2>/dev/null
        sleep 0.5
    fi
}

start_awww() {
    local wallpaper="$1"
    stop_all_daemons
    echo -e "${GREEN}Iniciando awww...${NC}"
    awww-daemon &
    disown
    sleep 1

    if [ -n "$wallpaper" ] && [ -f "$wallpaper" ]; then
        awww img "$wallpaper"
        echo -e "${GREEN}✓ awww ativo com wallpaper: $(basename "$wallpaper")${NC}"
    else
        awww restore 2>/dev/null
        echo -e "${GREEN}✓ awww ativo (wallpaper restaurado)${NC}"
    fi
}

start_neowall() {
    local shader_input="$1"

    # Verificar se neowall está instalado
    if ! command -v neowall &> /dev/null; then
        echo -e "${RED}✗ NeoWall não está instalado.${NC}"
        echo -e "  Instale com: ${YELLOW}yay -S neowall-git${NC}"
        exit 1
    fi

    # Usar shader padrão se não especificado
    local shader_name
    shader_name=$(resolve_shader "${shader_input:-$DEFAULT_SHADER}")

    # Verificar se o shader existe (built-in ou customizado)
    local shader_file="${shader_name}.glsl"
    if [ ! -f "$NEOWALL_BUILTIN_SHADERS/$shader_file" ] && [ ! -f "$NEOWALL_CUSTOM_SHADERS/$shader_file" ]; then
        echo -e "${RED}✗ Shader '$shader_name' não encontrado.${NC}"
        echo ""
        list_shaders
        exit 1
    fi

    stop_all_daemons

    # Gerar config.vibe dinâmico
    mkdir -p "$NEOWALL_CONFIG_DIR"
    cat > "$NEOWALL_CONFIG" << EOF
# Gerado automaticamente por wallpaper-mode.sh
# Shader: ${shader_name}
default {
    shader ${shader_file}
    shader_speed 0.8
}
EOF

    echo -e "${CYAN}Iniciando NeoWall com shader: ${shader_name}${NC}"
    neowall &
    disown
    sleep 2

    if pgrep -x neowall > /dev/null 2>&1; then
        echo -e "${CYAN}✓ NeoWall ativo com shader: ${shader_name}${NC}"
        echo -e "  ${DIM}Config: $NEOWALL_CONFIG${NC}"
        echo -e "  ${DIM}Comandos: neowall next | pause | resume | list${NC}"
    else
        echo -e "${RED}✗ Falha ao iniciar NeoWall. Voltando para awww...${NC}"
        start_awww
    fi
}

# --- Main ---

case "$1" in
    awww|static|restore)
        start_awww "$2"
        ;;
    neowall|shader|glsl)
        start_neowall "$2"
        ;;
    --status|-s)
        show_status
        ;;
    --list-shaders|--list|-l)
        list_shaders
        ;;
    *)
        echo -e "${YELLOW}wallpaper-mode.sh${NC} — Alterna entre awww e NeoWall"
        echo ""
        echo "Uso:"
        echo "  $(basename "$0") awww [imagem]      Ativa awww (wallpaper padrão)"
        echo "  $(basename "$0") neowall [shader]   Ativa NeoWall (shader GLSL)"
        echo "  $(basename "$0") --status           Mostra daemon ativo"
        echo "  $(basename "$0") --list-shaders     Lista shaders disponíveis"
        echo ""
        show_status
        exit 1
        ;;
esac
