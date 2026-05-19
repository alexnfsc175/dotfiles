#!/bin/bash

# Variaveis para forcar o uso da GPU NVIDIA
# export LIBVA_DRIVER_NAME=nvidia
# export XDG_SESSION_TYPE=wayland
# export GBM_BACKEND=nvidia-drm
# export __GLX_VENDOR_LIBRARY_NAME=nvidia
# export __GL_GSYNC_ALLOWED=0
# export __GL_VRR_ALLOWED=0
# export WLR_NO_HARDWARE_CURSORS=1
# export WLR_RENDERER_ALLOW_SOFTWARE=1

# Inicia o Hyprland
# exec Hyprland

# Se quiser garantir logs para debug, descomente a linha abaixo:
# export UWSM_LOG_LEVEL=debug

# Inicia o Hyprland através do gerenciador de sessão universal (UWSM)
# Ele vai carregar automaticamente as variáveis que definir no arquivo ~/.config/uwsm/env
exec uwsm start hyprland.desktop
