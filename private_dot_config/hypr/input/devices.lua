-- Dispositivos de input: teclado, mouse, touchpad
-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices

-- Configuração global de input
hl.config({
  input = {
    follow_mouse = 1,
    sensitivity  = 0,

    touchpad = {
      natural_scroll = true,
    },
  },
})

-- Teclado do Notebook / VM QEMU → Layout Americano Internacional (Padrão) + ABNT2 com alternância
hl.device({
  name       = "at-translated-set-2-keyboard",
  kb_layout  = "us,br",
  kb_variant = "intl,abnt2",
  kb_options = "grp:alt_shift_toggle",
})

-- Teclado Keychron K7 Pro → Layout Americano Internacional
hl.device({
  name       = "keychron-k7-pro-keyboard",
  kb_layout  = "us",
  kb_variant = "intl",
})

-- Mouse genérico (exemplo da config original)
hl.device({
  name        = "epic-mouse-v1",
  sensitivity = -0.5,
})
