-- Keybinds: Aplicativos
-- https://wiki.hypr.land/Configuring/Basics/Binds

local HYPRSCRIPTS  = os.getenv("HOME") .. "/.config/hypr/scripts"
local ROFI_SCRIPTS = os.getenv("HOME") .. "/.config/rofi/scripts"

-- Aplicativos padrão
local terminal     = "env GTK_IM_MODULE=simple ghostty"
local file_manager = "nemo"
-- local browser      = "google-chrome-stable --enable-features=SkiaGraphite,Vulkan --ozone-platform=x11 --use-angle=vulkan"
local browser      = "google-chrome-stable --ozone-platform=x11 --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --flag-switches-begin --enable-features=WebContentsForceDark --flag-switches-end --origin-trial-disabled-features=CanvasTextNg"

local menu         = "wofi --show drun"
local editor       = "alacritty -e nvim"

-- Abrir terminal
hl.bind("SUPER + RETURN", hl.dsp.exec_raw(terminal), {
  description = "Abrir terminal",
})

-- Abrir browser
hl.bind("SUPER + B", hl.dsp.exec_raw(browser), {
  description = "Abrir browser",
})

-- Abrir gerenciador de arquivos
hl.bind("SUPER + E", hl.dsp.exec_raw(file_manager), {
  description = "Abrir gerenciador de arquivos",
})

-- Emoji picker
hl.bind("SUPER + CTRL + E", hl.dsp.exec_raw(ROFI_SCRIPTS .. "/emoji/emoji"), {
  description = "Abrir emoji picker",
})

-- Application launcher
hl.bind("SUPER + CTRL + RETURN", hl.dsp.exec_raw(menu), {
  description = "Abrir application launcher",
})

-- Clipboard manager
hl.bind("SUPER + V", hl.dsp.exec_raw(ROFI_SCRIPTS .. "/clipboard/clipboard"), {
  description = "Abrir clipboard manager",
})
