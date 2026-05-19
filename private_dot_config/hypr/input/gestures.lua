-- Gestures de touchpad
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures

-- Swipe horizontal com 3 dedos → trocar workspace
hl.gesture({
  fingers   = 3,
  direction = "horizontal",
  action    = "workspace",
})

-- Swipe para baixo com 3 dedos + ALT → fechar janela
hl.gesture({
  fingers   = 3,
  direction = "down",
  mods      = "ALT",
  action    = "close",
})

-- Swipe para cima com 3 dedos + SUPER → fullscreen
hl.gesture({
  fingers   = 3,
  direction = "up",
  mods      = "SUPER",
  scale     = 1.5,
  action    = "fullscreen",
})
