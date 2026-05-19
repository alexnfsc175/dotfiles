-- Keybinds: Mídia e Hardware
-- Volume, brilho, playerctl, keyboard backlight

-- Brilho da tela
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_raw("brightnessctl -q s +10%"), { description = "Aumentar brilho 10%" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_raw("brightnessctl -q s 10%-"), { description = "Reduzir brilho 10%" })

-- Volume (com repeat ao segurar)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_raw("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), {
  repeating   = true,
  locked      = true,
  description = "Aumentar volume 5%",
})
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_raw("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), {
  repeating   = true,
  locked      = true,
  description = "Reduzir volume 5%",
})

-- Mute
hl.bind("XF86AudioMute",    hl.dsp.exec_raw("pactl set-sink-mute @DEFAULT_SINK@ toggle"),     { description = "Toggle mute" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_raw("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { description = "Toggle mute microfone" })

-- Player controls
hl.bind("XF86AudioPlay",  hl.dsp.exec_raw("playerctl play-pause"), { locked = true, description = "Play/Pause" })
hl.bind("XF86AudioPause", hl.dsp.exec_raw("playerctl pause"),      { locked = true, description = "Pause" })
hl.bind("XF86AudioNext",  hl.dsp.exec_raw("playerctl next"),       { locked = true, description = "Próxima faixa" })
hl.bind("XF86AudioPrev",  hl.dsp.exec_raw("playerctl previous"),   { locked = true, description = "Faixa anterior" })

-- Keyboard backlight (Fn keys por scancode)
hl.bind("code:238", hl.dsp.exec_raw("brightnessctl -d smc::kbd_backlight s +10"), { description = "Aumentar luz teclado" })
hl.bind("code:237", hl.dsp.exec_raw("brightnessctl -d smc::kbd_backlight s 10-"), { description = "Reduzir luz teclado" })

-- Teclas especiais
hl.bind("XF86ScreenSaver",  hl.dsp.exec_raw("hyprlock"), { description = "Bloquear tela" })
