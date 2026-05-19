-- Window Rules: comportamento geral de janelas
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules

-- Opacidade padrão via regra (permite que o opacity.lua ultrapasse esse limite depois)
hl.window_rule({
  match = { class = ".*" },
  opacity = "0.92 0.90",
})

-- Float presets: center-float-large
hl.window_rule({
  match = { class = "^(center-float-large)$" },
  float  = true,
  size   = "(monitor_w*0.7) (monitor_h*0.7)",
  center = true,
})

-- Float presets: center-float (diálogos Open/Save)
hl.window_rule({
  match = { class = "^(center-float)$" },
  float  = true,
  size   = "(monitor_w*0.5) (monitor_h*0.5)",
  center = true,
})

hl.window_rule({
  match = { title = "^(.*Open Folder.*)$|^(.*Open File.*)$|^(.*Save File.*)$|^(.*Save Folder.*)$|^(.*Save Image.*)$|^(.*Save As.*)$|^(.*Open As.*)$" },
  float  = true,
  size   = "(monitor_w*0.5) (monitor_h*0.5)",
  center = true,
})

-- Float presets: center-float-mini
hl.window_rule({
  match = { class = "^(center-float-mini)$|^(.*galculator.*)$|^(.*ytdlp-gui.*)$|^(.*udiskie.*)$|^(.*Calculator.*)$" },
  float  = true,
  size   = "(monitor_w*0.3) (monitor_h*0.4)",
  center = true,
})

-- Float: diálogos do sistema
local float_titles = { "Open", "Choose Files", "Save As", "Confirm to replace files", "File Operation Progress" }
for _, title in ipairs(float_titles) do
  hl.window_rule({
    match = { title = "^(" .. title .. ")$" },
    float = true,
  })
end

-- Float: xdg-desktop-portal
hl.window_rule({
  match = { class = "^([Xx]dg-desktop-portal-gtk)$" },
  float = true,
})

-- Float: mpv
hl.window_rule({
  match = { class = "^(mpv)$" },
  float = true,
  size  = "(monitor_w*0.6) (monitor_h*0.7)",
})

-- Float: FileRoller, Nemo Properties, PiP
hl.window_rule({
  match = { class = "^(org.gnome.FileRoller)$" },
  float = true,
})

hl.window_rule({
  match = { class = "^(nemo)$", title = "^(.*Properties.*)$" },
  float = true,
})

hl.window_rule({
  match = { title = "^(Picture-in-Picture)$" },
  float = true,
})

-- Tile: QEMU
hl.window_rule({
  match = { class = "^(qemu-system-x86_64)$" },
  tile = true,
})

-- Ignorar maximize de apps
hl.window_rule({
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- Fix arrasto de XWayland
hl.window_rule({
  match = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },
  no_focus = true,
})

-- XWaylandVideoBridge (screen sharing)
hl.window_rule({
  match = { class = "^(.*xwaylandvideobridge.*)$" },
  opacity          = "0.0 override 0.0 override",
  no_anim          = true,
  no_blur          = true,
  no_initial_focus = true,
  max_size         = "1 1",
})

-- Zathura (PDF viewer)
hl.window_rule({
  match = { class = "^(.*zathura.*)$" },
  float  = true,
  size   = "(monitor_w*0.35) (monitor_h*0.9)",
  center = true,
})

-- Scrcpy (espelhamento Android)
hl.window_rule({
  match = { class = "^(.*scrcpy.*)$" },
  float  = true,
  center = true,
})

-- Animações específicas
hl.window_rule({
  match     = { title = "^(.*cava.*)$" },
  animation = "slide",
})

hl.window_rule({
  match     = { class = "^(.*wleave.*)$" },
  animation = "popin",
})

-- Idle inhibit para jogos e mídia
hl.window_rule({
  match        = { class = "^(.*steam_app.*)$" },
  idle_inhibit = "always",
  immediate    = true,
})

hl.window_rule({
  match        = { class = "^(.*celluloid.*)$|^(.*mpv.*)$" },
  idle_inhibit = "fullscreen",
})

hl.window_rule({
  match        = { class = "^(.*LibreWolf.*)$|^(.*floorp.*)$|^(.*Brave.*)$|^(.*firefox.*)$|^(.*chromium.*)$|^(.*zen.*)$" },
  idle_inhibit = "fullscreen",
})

-- Apps que não devem roubar foco ao iniciar
hl.window_rule({
  match            = { class = "(.*[Ss]potify.*)|(.*tidal-hifi.*)$|(.*You[Tt]ube Music.*)" },
  no_initial_focus = true,
})
