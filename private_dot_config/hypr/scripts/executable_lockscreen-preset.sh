#!/bin/bash
# lockscreen-preset.sh — Alterna o preset do hyprlock
#
# Uso:
#   lockscreen-preset.sh <nome-do-preset>
#   lockscreen-preset.sh blur         # screenshot com blur (padrão)
#   lockscreen-preset.sh slideshow    # wallpapers rotativos
#   lockscreen-preset.sh cat-1        # preset cat-1 original
#   lockscreen-preset.sh cat-2        # preset cat-2 original
#   lockscreen-preset.sh --list       # lista presets disponíveis
#
# Os presets ficam em: ~/.config/hypr/hyprlock/presets/

HYPRLOCK_CONF="$HOME/.config/hypr/hyprlock.conf"
PRESETS_DIR="$HOME/.config/hypr/hyprlock/presets"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

list_presets() {
    echo -e "${YELLOW}Presets disponíveis:${NC}"
    local current
    current=$(grep -oP 'source = \./hyprlock/presets/\K[^.]+' "$HYPRLOCK_CONF" 2>/dev/null)
    for preset_file in "$PRESETS_DIR"/*.conf; do
        if [ -f "$preset_file" ]; then
            local name
            name=$(basename "$preset_file" .conf)
            if [ "$name" = "$current" ]; then
                echo -e "  ${GREEN}● $name (ativo)${NC}"
            else
                echo -e "  ○ $name"
            fi
        fi
    done
}

if [ "$1" = "--list" ] || [ "$1" = "-l" ]; then
    list_presets
    exit 0
fi

if [ -z "$1" ]; then
    echo -e "${RED}Erro: informe o nome do preset${NC}"
    echo ""
    list_presets
    echo ""
    echo "Uso: $(basename "$0") <nome-do-preset>"
    exit 1
fi

PRESET_NAME="$1"
PRESET_FILE="$PRESETS_DIR/${PRESET_NAME}.conf"

if [ ! -f "$PRESET_FILE" ]; then
    echo -e "${RED}Erro: preset '$PRESET_NAME' não encontrado em $PRESETS_DIR${NC}"
    echo ""
    list_presets
    exit 1
fi

# Atualiza o hyprlock.conf
sed -i "s|^source = \./hyprlock/presets/.*\.conf|source = ./hyprlock/presets/${PRESET_NAME}.conf|" "$HYPRLOCK_CONF"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Preset alterado para: ${PRESET_NAME}${NC}"
    echo -e "  Arquivo: $PRESET_FILE"
    echo -e "  Teste com: ${YELLOW}hyprlock --immediate${NC}"
else
    echo -e "${RED}✗ Erro ao alterar o preset${NC}"
    exit 1
fi
