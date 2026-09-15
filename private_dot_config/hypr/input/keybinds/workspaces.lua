-- Keybinds: Workspaces & Telas Virtuais (Opção 3)
-- https://wiki.hypr.land/Configuring/Basics/Binds
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules

local HYPRSCRIPTS = os.getenv("HOME") .. "/.config/hypr/scripts"
local config = require("core.config")

local screens = config.screens
local connected_set = config.get_connected_set()
local is_docked = config.is_docked()

-- Estado das Telas Virtuais (quando em modo laptop)
local current_screen = 1
local last_workspace = {
  [1] = 1,
  [2] = 4,
  [3] = 7,
}

-- Identifica a qual tela um workspace pertence (1, 2 ou 3)
local function get_screen_for_ws(ws)
  for _, screen in ipairs(screens) do
    for _, w in ipairs(screen.workspaces) do
      if w == ws then
        return screen
      end
    end
  end
  return screens[1]
end

-- =============================================================================
-- 1. Regras de Workspaces (Mapeamento Dinâmico)
-- =============================================================================
local primary_monitor = config.get_primary_monitor()

for _, screen in ipairs(screens) do
  for _, ws in ipairs(screen.workspaces) do
    if is_docked and connected_set[screen.monitor] then
      -- Modo Docked: amarra cada workspace ao seu monitor físico correspondente
      hl.workspace_rule({ workspace = ws, monitor = screen.monitor, persistent = true })
    else
      -- Modo Laptop (ou monitor desconectado): garante que os 9 workspaces fiquem na tela ativa principal
      hl.workspace_rule({ workspace = ws, monitor = primary_monitor, persistent = true })
    end
  end
end

-- =============================================================================
-- 2. Funções de Controle das Telas Virtuais
-- =============================================================================
local function focus_screen(screen_id)
  local screen = screens[screen_id]
  if not screen then return end
  current_screen = screen_id

  if is_docked and connected_set[screen.monitor] then
    -- Modo Docked: foca o monitor físico
    hl.dispatch(hl.dsp.focus({ monitor = screen.monitor }))
  else
    -- Modo Laptop: foca o último workspace ativo desta Tela Virtual
    local target_ws = last_workspace[screen_id] or screen.workspaces[1]
    hl.dispatch(hl.dsp.focus({ workspace = tostring(target_ws) }))

    -- Feedback visual discreto no topo
    local notify_cmd = string.format(
      "notify-send -t 1200 -h string:x-canonical-private-synchronous:vscreen '🖥️ Tela Virtual %d: %s' 'Workspaces: %d, %d, %d'",
      screen.id, screen.name, screen.workspaces[1], screen.workspaces[2], screen.workspaces[3]
    )
    hl.exec_cmd(notify_cmd)
  end
end

local function cycle_screen(direction)
  local next_id = current_screen + direction
  if next_id > #screens then next_id = 1 end
  if next_id < 1 then next_id = #screens end
  focus_screen(next_id)
end

-- =============================================================================
-- 3. Keybinds para Workspaces Diretos (SUPER + 1..9)
-- =============================================================================
for _, screen in ipairs(screens) do
  for _, ws in ipairs(screen.workspaces) do
    local key = tostring(ws)

    -- Abrir workspace (e atualizar a Tela Virtual ativa)
    hl.bind("SUPER + " .. key, function()
      current_screen = screen.id
      last_workspace[screen.id] = ws
      hl.dispatch(hl.dsp.focus({ workspace = tostring(ws) }))
    end, { description = "Abrir workspace " .. ws .. " (" .. screen.name .. ")" })

    -- Mover janela ativa para o workspace
    hl.bind("SUPER + SHIFT + " .. key, function()
      last_workspace[screen.id] = ws
      hl.dispatch(hl.dsp.window.move({ workspace = tostring(ws) }))
    end, { description = "Mover janela para workspace " .. ws })

    -- Mover todas as janelas do workspace atual para o workspace alvo
    hl.bind("SUPER + CTRL + " .. key, hl.dsp.exec_raw(HYPRSCRIPTS .. "/moveTo.sh " .. ws), {
      description = "Mover todas as janelas para workspace " .. ws,
    })
  end
end

-- =============================================================================
-- 4. Keybinds para Telas Virtuais (SUPER + ALT + 1/2/3 e SUPER + F1/F2/F3)
-- =============================================================================
for s_idx, screen in ipairs(screens) do
  local s_key = tostring(s_idx)

  -- Focar Tela Virtual (SUPER + ALT + 1/2/3)
  hl.bind("SUPER + ALT + " .. s_key, function()
    focus_screen(s_idx)
  end, { description = "Focar Tela Virtual " .. s_idx .. " (" .. screen.name .. ")" })

  -- Focar Tela Virtual (SUPER + F1/F2/F3)
  hl.bind("SUPER + F" .. s_key, function()
    focus_screen(s_idx)
  end, { description = "Focar Tela Virtual " .. s_idx .. " (" .. screen.name .. ")" })

  -- Mover janela para a Tela Virtual (SUPER + ALT + SHIFT + 1/2/3)
  hl.bind("SUPER + ALT + SHIFT + " .. s_key, function()
    local target_ws = last_workspace[s_idx] or screen.workspaces[1]
    hl.dispatch(hl.dsp.window.move({ workspace = tostring(target_ws) }))
    local notify_cmd = string.format(
      "notify-send -t 1200 -h string:x-canonical-private-synchronous:vscreen 'Janela movida' 'Movida para %s (Workspace %d)'",
      screen.name, target_ws
    )
    hl.exec_cmd(notify_cmd)
  end, { description = "Mover janela para Tela Virtual " .. s_idx })
end

-- Ciclar Telas Virtuais (SUPER + [ / ])
hl.bind("SUPER + bracketleft",  function() cycle_screen(-1) end, { description = "Tela Virtual anterior" })
hl.bind("SUPER + bracketright", function() cycle_screen(1) end,  { description = "Próxima Tela Virtual" })

-- =============================================================================
-- 5. Navegação Sequencial de Workspaces e Scroll
-- =============================================================================
hl.bind("SUPER + Tab",         hl.dsp.focus({ workspace = "m+1" }), { description = "Próximo workspace" })
hl.bind("SUPER + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }), { description = "Workspace anterior" })

hl.bind("SUPER + mouse_down",  hl.dsp.focus({ workspace = "e+1" }), { description = "Próximo workspace (scroll)" })
hl.bind("SUPER + mouse_up",    hl.dsp.focus({ workspace = "e-1" }), { description = "Workspace anterior (scroll)" })

hl.bind("SUPER + CTRL + down", hl.dsp.focus({ workspace = "empty" }), { description = "Workspace vazio" })
