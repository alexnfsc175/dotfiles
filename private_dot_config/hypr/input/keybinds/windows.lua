-- Keybinds: Gerenciamento de Janelas
-- https://wiki.hypr.land/Configuring/Basics/Binds

local HYPRSCRIPTS = os.getenv("HOME") .. "/.config/hypr/scripts"

-- Fechar janela ativa (graciosamente)
hl.bind("SUPER + Q", hl.dsp.window.close(), {
  description = "Fechar janela ativa",
})

-- Fechar janela e todas as instâncias (matando o processo)
hl.bind("SUPER + SHIFT + Q", hl.dsp.window.kill(), {
  description = "Encerrar janela e todas as instâncias",
})

-- Fullscreen
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = 0 }), {
  description = "Fullscreen",
})

-- Maximize
hl.bind("SUPER + M", hl.dsp.window.fullscreen({ mode = 1 }), {
  description = "Maximizar janela",
})

-- Toggle floating
hl.bind("SUPER + T", hl.dsp.window.float(), {
  description = "Toggle floating",
})

-- Toggle all floating (agora em Lua nativo)
hl.bind("SUPER + SHIFT + T", function()
  local ws = hl.get_active_workspace()
  if not ws then return end
  local windows = hl.get_workspace_windows(ws)
  if not windows or #windows == 0 then return end

  local any_tiled = false
  for _, w in ipairs(windows) do
    if not w.floating then
      any_tiled = true
      break
    end
  end

  local target_action = any_tiled and "set" or "unset"
  
  for _, w in ipairs(windows) do
    hl.dispatch(hl.dsp.window.float({ action = target_action, window = "address:" .. tostring(w.address) }))
  end
end, {
  description = "Toggle all floating",
})

-- Toggle split (dwindle)
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"), {
  description = "Toggle split",
})

-- Swap split (dwindle)
hl.bind("SUPER + K", hl.dsp.layout("swapsplit"), {
  description = "Swap split",
})

-- Toggle window group
hl.bind("SUPER + G", hl.dsp.group.toggle(), {
  description = "Toggle grupo de janelas",
})

-- Mover foco com setas
hl.bind("SUPER + left",  hl.dsp.focus({ direction = "l" }), { description = "Foco esquerda" })
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }), { description = "Foco direita" })
hl.bind("SUPER + up",    hl.dsp.focus({ direction = "u" }), { description = "Foco cima" })
hl.bind("SUPER + down",  hl.dsp.focus({ direction = "d" }), { description = "Foco baixo" })

-- Redimensionar janela com teclado
hl.bind("SUPER + SHIFT + right", hl.dsp.window.resize({ x = 100, y = 0, relative = true }),  { description = "Aumentar largura" })
hl.bind("SUPER + SHIFT + left",  hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { description = "Reduzir largura" })
hl.bind("SUPER + SHIFT + down",  hl.dsp.window.resize({ x = 0, y = 100, relative = true }),  { description = "Aumentar altura" })
hl.bind("SUPER + SHIFT + up",    hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { description = "Reduzir altura" })

-- Trocar janela tiled de posição
hl.bind("SUPER + ALT + left",  hl.dsp.window.swap({ direction = "l" }), { description = "Swap janela esquerda" })
hl.bind("SUPER + ALT + right", hl.dsp.window.swap({ direction = "r" }), { description = "Swap janela direita" })
hl.bind("SUPER + ALT + up",    hl.dsp.window.swap({ direction = "u" }), { description = "Swap janela cima" })
hl.bind("SUPER + ALT + down",  hl.dsp.window.swap({ direction = "d" }), { description = "Swap janela baixo" })

-- Mover/redimensionar janela com mouse
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true, description = "Mover janela com mouse" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Redimensionar com mouse" })

-- Cycle entre janelas (ALT+Tab)
hl.bind("ALT + Tab", hl.dsp.window.cycle_next(),        { repeating = true, description = "Ciclar janelas" })
hl.bind("ALT + Tab", hl.dsp.window.bring_to_top(), { repeating = true, description = "Trazer janela ao topo" })
