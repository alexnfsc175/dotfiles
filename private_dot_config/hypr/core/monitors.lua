-- Monitores
-- https://wiki.hypr.land/Configuring/Basics/Monitors

local config = require("core.config")

-- Aplica configuração física de cada monitor a partir da lista centralizada em core/config.lua
for _, screen in ipairs(config.screens) do
  hl.monitor({
    output   = screen.monitor,
    mode     = screen.mode,
    position = screen.position,
    scale    = screen.scale or 1.0,
  })
end



-- Monitor Hotplug Handler
-- Reconfigura workspaces e Telas Virtuais quando monitores são conectados/desconectados
hl.on("monitor.added", function(monitor)
  -- Recarrega configuração para re-vincular workspaces aos monitores físicos
  hl.exec_cmd("hyprctl reload")
end)

hl.on("monitor.removed", function(monitor)
  -- Recarrega configuração para converter para o modo de Telas Virtuais no notebook
  hl.exec_cmd("hyprctl reload")
end)
