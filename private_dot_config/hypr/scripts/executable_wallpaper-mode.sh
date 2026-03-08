#!/bin/bash
# wallpaper-mode.sh — Alterna entre awww (wallpaper estático/GIF) e NeoWall (shader GLSL)
#
# Uso:
#   wallpaper-mode.sh awww                  # Volta para awww (wallpaper padrão)
#   wallpaper-mode.sh awww <imagem>         # Volta para awww com wallpaper específico
#   wallpaper-mode.sh neowall <shader>      # Ativa NeoWall com shader GLSL
#   wallpaper-mode.sh neowall               # Ativa NeoWall com shader padrão
#   wallpaper-mode.sh --status              # Mostra qual está ativo
#   wallpaper-mode.sh --list-shaders        # Lista shaders disponíveis
#
# Requer: awww-git, neowall-git (yay -S neowall-git)
#
# Os shaders ficam em: ~/.config/hypr/shaders/

SHADERS_DIR="$HOME/.config/hypr/shaders"
DEFAULT_SHADER="$SHADERS_DIR/plasma.glsl"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

show_status() {
    if pgrep -x neowall > /dev/null 2>&1; then
        echo -e "${CYAN}● NeoWall${NC} (shader GLSL ativo)"
    elif pgrep -x awww-daemon > /dev/null 2>&1 || pgrep -x awww > /dev/null 2>&1; then
        echo -e "${GREEN}● awww${NC} (wallpaper padrão ativo)"
    else
        echo -e "${RED}● Nenhum${NC} daemon de wallpaper ativo"
    fi
}

list_shaders() {
    echo -e "${YELLOW}Shaders disponíveis em $SHADERS_DIR:${NC}"
    if [ ! -d "$SHADERS_DIR" ] || [ -z "$(ls -A "$SHADERS_DIR"/*.glsl 2>/dev/null)" ]; then
        echo -e "  ${RED}Nenhum shader encontrado.${NC}"
        echo -e "  Adicione arquivos .glsl em $SHADERS_DIR"
        echo -e "  Dica: Baixe shaders de https://shadertoy.com"
        return 1
    fi
    for shader in "$SHADERS_DIR"/*.glsl; do
        local name
        name=$(basename "$shader" .glsl)
        echo -e "  ○ $name  →  $shader"
    done
}

stop_all_daemons() {
    # Para NeoWall
    if pgrep -x neowall > /dev/null 2>&1; then
        echo -e "  Parando NeoWall..."
        killall neowall 2>/dev/null
        sleep 0.5
    fi
    # Para awww
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
    local shader="$1"

    # Verificar se neowall está instalado
    if ! command -v neowall &> /dev/null; then
        echo -e "${RED}✗ NeoWall não está instalado.${NC}"
        echo -e "  Instale com: ${YELLOW}yay -S neowall-git${NC}"
        exit 1
    fi

    # Usar shader padrão se não especificado
    if [ -z "$shader" ]; then
        shader="$DEFAULT_SHADER"
    fi

    # Se o argumento é só o nome (sem path), buscar no diretório de shaders
    if [ ! -f "$shader" ] && [ -f "$SHADERS_DIR/$shader" ]; then
        shader="$SHADERS_DIR/$shader"
    elif [ ! -f "$shader" ] && [ -f "$SHADERS_DIR/${shader}.glsl" ]; then
        shader="$SHADERS_DIR/${shader}.glsl"
    fi

    if [ ! -f "$shader" ]; then
        echo -e "${RED}✗ Shader não encontrado: $shader${NC}"
        echo ""
        list_shaders
        exit 1
    fi

    stop_all_daemons
    echo -e "${CYAN}Iniciando NeoWall com shader: $(basename "$shader")${NC}"
    neowall --shader "$shader" &
    disown
    sleep 1

    if pgrep -x neowall > /dev/null 2>&1; then
        echo -e "${CYAN}✓ NeoWall ativo com shader: $(basename "$shader" .glsl)${NC}"
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
    --list-shaders|-l)
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
