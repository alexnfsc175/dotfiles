-- Keybinds: Workspaces
-- https://wiki.hypr.land/Configuring/Basics/Binds

local HYPRSCRIPTS = os.getenv("HOME") .. "/.config/hypr/scripts"

-- Workspace → Monitor mapping (carregado de core/config.lua)
local config = require("core.config")
local monitors = config.monitors
local ws_per_monitor = config.ws_per_monitor

for i, monitor in ipairs(monitors) do
  for j = 1, ws_per_monitor do
    local ws = (i - 1) * ws_per_monitor + j
    local key = tostring(ws)

    -- Mapear workspace para monitor
    hl.workspace_rule({ workspace = ws, monitor = monitor, persistent = true })

    -- Trocar para workspace
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = tostring(ws) }), {
      description = "Abrir workspace " .. ws,
    })

    -- Mover janela para workspace
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(ws) }), {
      description = "Mover janela para workspace " .. ws,
    })

    -- Mover todas as janelas para workspace
    hl.bind("SUPER + CTRL + " .. key, hl.dsp.exec_raw(HYPRSCRIPTS .. "/moveTo.sh " .. ws), {
      description = "Mover todas as janelas para workspace " .. ws,
    })
  end
end

-- Navegação sequencial
hl.bind("SUPER + Tab",       hl.dsp.focus({ workspace = "m+1" }), { description = "Próximo workspace" })
hl.bind("SUPER + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }), { description = "Workspace anterior" })

-- Scroll mouse para navegar workspaces
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Próximo workspace (scroll)" })
hl.bind("SUPER + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), { description = "Workspace anterior (scroll)" })

-- Ir para próximo workspace vazio
hl.bind("SUPER + CTRL + down", hl.dsp.focus({ workspace = "empty" }), { description = "Workspace vazio" })
