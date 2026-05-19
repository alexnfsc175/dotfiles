-- Autostart
-- https://wiki.hypr.land/Configuring/Basics/Autostart

local HOME = os.getenv("HOME")
local SCRIPTS = HOME .. "/.config/hypr/scripts"

-- Serviços e apps via scripts existentes
hl.on("hyprland.start", function()
  hl.exec_cmd(SCRIPTS .. "/autostart/services")
  hl.exec_cmd(SCRIPTS .. "/autostart/apps")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)
