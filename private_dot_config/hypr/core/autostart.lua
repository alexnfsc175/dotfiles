-- Autostart
-- https://wiki.hypr.land/Configuring/Basics/Autostart
-- Migrado de shell scripts para Lua nativo

local HOME = os.getenv("HOME")

-- Serviços essenciais
hl.on("hyprland.start", function()
  -- D-Bus environment
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

  -- Status Bar: QuickShell (comentar para usar Waybar)
  hl.exec_cmd("uwsm app -- quickshell")
  -- hl.exec_cmd("uwsm app -- waybar")

  -- Wallpaper Backend
  hl.exec_cmd("uwsm app -- awww-daemon --format xrgb")

  -- Notification Daemon
  hl.exec_cmd("uwsm app -- swaync")

  -- OSD Window
  hl.exec_cmd("uwsm app -- swayosd-server")

  -- Idle daemon to screen lock
  hl.exec_cmd("uwsm app -- hypridle")

  -- Clipboard
  hl.exec_cmd("uwsm app -- wl-paste --watch cliphist store")

  -- Polkit authentication
  hl.exec_cmd("uwsm app -- /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

  -- Automounter for removable media
  hl.exec_cmd("uwsm app -- udiskie")
end)

-- Apps opcionais (descomente conforme necessário)
-- hl.on("hyprland.start", function()
--   hl.exec_cmd("uwsm app -- spotify")
--   hl.exec_cmd("uwsm app -- vesktop")
--   hl.exec_cmd("uwsm app -- thunderbird")
--   hl.exec_cmd("uwsm app -- obsidian")
-- end)
