-- Monitores
-- https://wiki.hypr.land/Configuring/Basics/Monitors

local config = require("core.config")

-- Fallback genérico para qualquer monitor não explicitamente configurado
hl.monitor({
  output   = "",
  mode     = "preferred",
  position = "auto",
  scale    = 1.0,
})

-- Aplica configuração física de cada monitor a partir da lista dinâmica de core/config.lua
for _, screen in ipairs(config.screens) do
  hl.monitor({
    output   = screen.monitor,
    mode     = screen.mode,
    position = screen.position,
    scale    = screen.scale or 1.0,
  })
end

-- Monitor Hotplug Handler
-- Protegido contra reloads durante o boot inicial e com debounce para múltiplos monitores
local boot_ready = false
local last_reload = 0

local function debounced_reload()
  if not boot_ready then return end
  local now = os.clock()
  if (now - last_reload) < 1.5 then return end
  last_reload = now
  hl.exec_cmd("hyprctl reload")
end

-- O monitor hotplug só deve disparar após o Hyprland completar o boot
hl.on("hyprland.start", function()
  boot_ready = true
  last_reload = os.clock()
end)

hl.on("monitor.added", function(monitor)
  debounced_reload()
end)

hl.on("monitor.removed", function(monitor)
  debounced_reload()
end)
