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

-- Sanitiza janelas flutuantes para não estourarem a resolução do monitor atual
local function sanitize_floating_window(addr_str, mon)
  local win = hl.get_window(addr_str)
  if not win or not win.floating then return end

  local m = mon or win.monitor or hl.get_active_monitor()
  if not m or not m.width or not m.height then return end

  -- Limite máximo para a janela flutuante caber na tela atual (85% da resolução)
  local max_w = math.floor(m.width * 0.85)
  local max_h = math.floor(m.height * 0.85)

  local needs_resize = (win.size.x > max_w or win.size.y > max_h)
  local needs_reposition = false

  if needs_resize then
    local scale = math.min(max_w / win.size.x, max_h / win.size.y)
    local target_w = math.max(300, math.floor(win.size.x * scale))
    local target_h = math.max(200, math.floor(win.size.y * scale))
    hl.dispatch(hl.dsp.window.resize({ x = target_w, y = target_h, window = addr_str }))
    needs_reposition = true
  end

  -- Verificar se a janela está total ou parcialmente fora dos limites visíveis do monitor
  if not needs_reposition then
    local mon_right = m.x + m.width
    local mon_bottom = m.y + m.height
    if win.at.x < m.x or (win.at.x + win.size.x) > mon_right or
       win.at.y < m.y or (win.at.y + win.size.y) > mon_bottom then
      needs_reposition = true
    end
  end

  if needs_reposition then
    hl.dispatch(hl.dsp.window.center({ window = addr_str }))
  end
end

-- Toggle floating (com sanitização inteligente de resolução)
hl.bind("SUPER + T", function()
  local w = hl.get_active_window()
  if not w then return end
  local addr_str = "address:" .. tostring(w.address)
  local m = w.monitor or hl.get_active_monitor()

  if w.floating then
    -- Se já está flutuando, verifica se está estourando a tela (ex: vindo de monitor maior)
    local max_w = m and math.floor(m.width * 0.85) or 1600
    local max_h = m and math.floor(m.height * 0.85) or 900
    if w.size.x > max_w or w.size.y > max_h then
      sanitize_floating_window(addr_str, m)
      return
    end
    -- Se já está com tamanho adequado, desativa o floating (volta para tiled)
    hl.dispatch(hl.dsp.window.float({ action = "unset", window = addr_str }))
  else
    -- Ativa o floating e ajusta tamanho/posição para caber no monitor atual
    hl.dispatch(hl.dsp.window.float({ action = "set", window = addr_str }))
    sanitize_floating_window(addr_str, m)
  end
end, {
  description = "Toggle floating",
})

-- Centralizar janela flutuante ativa
hl.bind("SUPER + C", function()
  local w = hl.get_active_window()
  if not w then return end
  local addr_str = "address:" .. tostring(w.address)
  if w.floating then
    sanitize_floating_window(addr_str, w.monitor or hl.get_active_monitor())
  end
  hl.dispatch(hl.dsp.window.center({ window = addr_str }))
end, {
  description = "Centralizar janela",
})

-- Toggle all floating (com sanitização inteligente de resolução)
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
  local m = hl.get_active_monitor()

  for _, w in ipairs(windows) do
    local addr_str = "address:" .. tostring(w.address)
    hl.dispatch(hl.dsp.window.float({ action = target_action, window = addr_str }))
    if target_action == "set" then
      sanitize_floating_window(addr_str, w.monitor or m)
    end
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

-- Mover janela para monitor adjacente
hl.bind("SUPER + CTRL + left",  hl.dsp.window.move({ monitor = "l" }), { description = "Mover janela para monitor esquerda" })
hl.bind("SUPER + CTRL + right", hl.dsp.window.move({ monitor = "r" }), { description = "Mover janela para monitor direita" })
hl.bind("SUPER + CTRL + up",    hl.dsp.window.move({ monitor = "u" }), { description = "Mover janela para monitor cima" })
hl.bind("SUPER + CTRL + down",  hl.dsp.window.move({ monitor = "d" }), { description = "Mover janela para monitor baixo" })

-- Cycle entre janelas (ALT+Tab)
hl.bind("ALT + Tab", hl.dsp.window.cycle_next(), { repeating = true, description = "Ciclar janelas" })
