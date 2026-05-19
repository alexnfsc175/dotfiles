-- Layer Rules
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/#layer-rules

-- Rofi (app launcher)
hl.layer_rule({
  match     = { namespace = "rofi" },
  animation = "popin",
  blur      = true,
  ignore_alpha = 0,
})

-- Waybar (barra de status)
hl.layer_rule({
  match        = { namespace = "waybar" },
  blur         = true,
  ignore_alpha = 0,
})

-- SwayNC (notificações)
hl.layer_rule({
  match        = { namespace = "swaync-notification-window" },
  animation    = "slide",
  ignore_alpha = 0,
})

hl.layer_rule({
  match     = { namespace = "swaync-control-center" },
  animation = "slide",
})

-- SwayOSD (indicadores de volume/brilho)
hl.layer_rule({
  match     = { namespace = "swayosd" },
  animation = "fade",
})

-- Seleção (screenshot, color picker)
hl.layer_rule({
  match     = { namespace = "selection" },
  animation = "fade",
})

-- Hyprlock (tela de bloqueio)
hl.layer_rule({
  match     = { namespace = "hyprlock" },
  animation = "fade",
})

-- Hyprpicker (color picker)
hl.layer_rule({
  match  = { namespace = "hyprpicker" },
  no_anim = true,
})
