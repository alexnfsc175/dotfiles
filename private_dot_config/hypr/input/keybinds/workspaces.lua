-- Keybinds: Workspaces
-- https://wiki.hypr.land/Configuring/Basics/Binds

local HYPRSCRIPTS = os.getenv("HOME") .. "/.config/hypr/scripts"

-- Trocar para workspace 1-10
for i = 1, 10 do
  local key = i == 10 and "0" or tostring(i)

  hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = tostring(i) }), {
    description = "Abrir workspace " .. i,
  })

  hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(i) }), {
    description = "Mover janela para workspace " .. i,
  })

  hl.bind("SUPER + CTRL + " .. key, hl.dsp.exec_raw(HYPRSCRIPTS .. "/moveTo.sh " .. i), {
    description = "Mover todas as janelas para workspace " .. i,
  })
end

-- Navegação sequencial
hl.bind("SUPER + Tab",       hl.dsp.focus({ workspace = "m+1" }), { description = "Próximo workspace" })
hl.bind("SUPER + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }), { description = "Workspace anterior" })

-- Scroll mouse para navegar workspaces
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Próximo workspace (scroll)" })
hl.bind("SUPER + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), { description = "Workspace anterior (scroll)" })

-- Ir para próximo workspace vazio
hl.bind("SUPER + CTRL + down", hl.dsp.focus({ workspace = "empty" }), { description = "Workspace vazio" })
