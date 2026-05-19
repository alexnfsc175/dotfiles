#!/bin/bash

MIN=0.4
MAX=1.0
INPUT=${1:-"+"}
STEP=${2:-0.05}
STATE_DIR="/tmp/hypr_opacity_states"

# 1. Obtém o endereço da janela atual
WINDOW_JSON=$(hyprctl activewindow -j)
ADDR=$(echo "$WINDOW_JSON" | jq -r '.address // empty')

if [ -z "$ADDR" ] || [ "$ADDR" == "null" ]; then exit 0; fi

mkdir -p "$STATE_DIR"
STATE_FILE="$STATE_DIR/$ADDR"

# 2. Determina a opacidade atual (Prioridade: Arquivo de Estado > Janela > Global)
if [ -f "$STATE_FILE" ]; then
    CURRENT=$(cat "$STATE_FILE")
else
    # Se não houver estado salvo, tenta pegar do Hyprland
    WIN_OPAC=$(echo "$WINDOW_JSON" | jq -r '.opacity // empty')
    GLOB_OPAC=$(hyprctl getoption decoration:active_opacity -j | jq -r '.float // 1.0')
    CURRENT=${WIN_OPAC:-$GLOB_OPAC}
fi

# 3. Cálculo Matemático no JQ (Garante que o resultado seja numérico e sem aspas)
NEW_OPACITY=$(jq -n \
    --arg cur "$CURRENT" \
    --arg in "$INPUT" \
    --arg min "$MIN" \
    --arg max "$MAX" \
    --arg step "$STEP" \
    '
    ($cur | tonumber) as $c |
    ($min | tonumber) as $mn |
    ($max | tonumber) as $mx |
    ($step | tonumber) as $s |
    
    if $in == "+" then
        (if ($c + $s) > $mx then $mx else ($c + $s) end)
    elif $in == "-" then
        (if ($c - $s) < $mn then $mn else ($c - $s) end)
    else
        ($in | tonumber | if . > $mx then $mx elif . < $mn then $mn else . end)
    end | tonumber')

echo "Current: $CURRENT, New: $NEW_OPACITY"
echo "ADDR: $ADDR"

# 4. Aplica ao Hyprland e Salva o Estado
# Usamos socket UNIX via Python para evitar bug no 'hyprctl dispatch setprop' no 0.55+
python3 -c "
import socket, os
s = socket.socket(socket.AF_UNIX)
sock_path = f'/run/user/{os.getuid()}/hypr/{os.getenv(\"HYPRLAND_INSTANCE_SIGNATURE\")}/.socket.sock'
try:
    s.connect(sock_path)
    s.send(f'dispatch setprop address:$ADDR opacity $NEW_OPACITY'.encode())
except Exception as e:
    print(f'Erro de socket: {e}')
"

echo "$NEW_OPACITY" > "$STATE_FILE"

# Nota o limite de opacidade é controlado por decoration.conf, entao mesmo que o script tente setar um valor fora do range, o Hyprland vai limitar automaticamente, de acordo com o active_opacity e inactive_opacity definidos lá.
# hyprctl keyword decoration:active_opacity 1.0 
# hyprctl keyword decoration:inactive_opacity 0.8