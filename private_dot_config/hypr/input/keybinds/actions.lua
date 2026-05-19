-- Keybinds: Ações do sistema
-- Reload, screenshot, wallpaper, powermenu, opacity, zoom

local HYPRSCRIPTS  = os.getenv("HOME") .. "/.config/hypr/scripts"
local ROFI_SCRIPTS = os.getenv("HOME") .. "/.config/rofi/scripts"

-- Opacity toggle
local opacity = require("scripts.opacity")

-- Reload config
hl.bind("SUPER + CTRL + R", hl.dsp.exec_raw("hyprctl reload"), {
  description = "Recarregar configuração",
})

-- Toggle animações
hl.bind("SUPER + SHIFT + A", function()
  local current = hl.get_config("animations:enabled")
  hl.config({ animations = { enabled = not current } })
end, {
  description = "Toggle animações",
})

-- Screenshot
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_raw(ROFI_SCRIPTS .. "/screenshot/screenshot"), {
  description = "Tirar screenshot",
})

-- Powermenu
hl.bind("SUPER + CTRL + Q", hl.dsp.exec_raw(ROFI_SCRIPTS .. "/powermenu/powermenu"), {
  description = "Abrir powermenu",
})

-- Wallpaper
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_raw(HYPRSCRIPTS .. "/cycle_wallpaper.sh --same"), {
  description = "Trocar wallpaper",
})

hl.bind("SUPER + ALT + equal", function() opacity.change("+") end, {
  description = "Aumentar opacidade da janela",
})
hl.bind("SUPER + ALT + minus", function() opacity.change("-") end, {
  description = "Reduzir opacidade da janela",
})

-- Display zoom
hl.bind("SUPER + SHIFT + mouse_down", function()
  local current = hl.get_config("cursor:zoom_factor") or 1.0
  hl.config({ cursor = { zoom_factor = current + 0.5 } })
end, { description = "Aumentar zoom" })

hl.bind("SUPER + SHIFT + mouse_up", function()
  local current = hl.get_config("cursor:zoom_factor") or 1.0
  local new_zoom = math.max(1.0, current - 0.5)
  hl.config({ cursor = { zoom_factor = new_zoom } })
end, { description = "Reduzir zoom" })

hl.bind("SUPER + SHIFT + Z", function()
  hl.config({ cursor = { zoom_factor = 1.0 } })
end, {
  description = "Resetar zoom",
})
