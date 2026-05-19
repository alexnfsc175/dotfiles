#!/usr/bin/bash

# Diretório onde os wallpapers estão armazenados
WALL_DIR="$HOME/.config/hypr/theme/walls/"

# Obtém a lista de monitores ativos usando awww query
MONITORS=$(awww query | awk '{print $2}' | sed s/://)

# Verifica se o parâmetro -s ou --same foi passado
USE_SAME=false
if [[ "$1" == "-s" || "$1" == "--same" ]]; then
    USE_SAME=true
    # Seleciona um único wallpaper aleatório para todos
    SINGLE_RANDOM=$(fd --base-directory "$WALL_DIR" --type f . | shuf -n 1)
else
    # Cria um stream de wallpapers embaralhados
    exec 3< <(fd --base-directory "$WALL_DIR" --type f . | shuf)
fi

for monitor in $MONITORS; do
    if [ "$USE_SAME" = true ]; then
        random="$SINGLE_RANDOM"
    else
        # Lê a próxima linha do stream embaralhado
        read -u 3 random
        
        # Se a variável estiver vazia (acabaram os wallpapers da lista), recarrega a lista
        if [ -z "$random" ]; then
            exec 3< <(fd --base-directory "$WALL_DIR" --type f . | shuf)
            read -u 3 random
        fi
    fi

    wallpaper="$WALL_DIR$random"

    # Aplica o wallpaper no monitor específico usando awww
    awww img --outputs "$monitor" "$wallpaper" \
        --transition-bezier 0.5,1.19,.8,.4 \
        --transition-type outer \
        --transition-duration 2 \
        --transition-pos top-right \
        --transition-fps 75
done

# Fecha o descritor de arquivo se foi aberto
if [ "$USE_SAME" = false ]; then
    exec 3<&-
fi

if [ "$USE_SAME" = true ]; then
    MSG="Unified Wallpaper Changed"
else
    MSG="Wallpaper Changed for all monitors (Random)"
fi

notify-send "$MSG" --app-name=Wallpaper
