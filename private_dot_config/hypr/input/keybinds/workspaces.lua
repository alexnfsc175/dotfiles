-- Keybinds: Workspaces & Telas Virtuais (Opção 3)
-- https://wiki.hypr.land/Configuring/Basics/Binds
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules

local HYPRSCRIPTS = os.getenv("HOME") .. "/.config/hypr/scripts"
local config = require("core.config")

local screens = config.screens
local connected_set = config.get_connected_set()
local is_docked = config.is_docked()

-- =============================================================================
-- 1. Regras de Workspaces (Mapeamento Dinâmico)
-- =============================================================================
-- Cada tela ativa vincula seus workspaces como persistentes no monitor conectado correspondente
for _, screen in ipairs(screens) do
  for _, ws in ipairs(screen.workspaces) do
    hl.workspace_rule({
      workspace = ws,
      monitor = screen.monitor,
      persistent = true,
    })
  end
end

-- =============================================================================
-- 2. Grupos de Telas (Físicas se multi-monitor, Virtuais se tela única)
-- =============================================================================
local screen_groups = {}
if #screens > 1 then
  for i, screen in ipairs(screens) do
    table.insert(screen_groups, {
      id          = i,
      name        = screen.name,
      monitor     = screen.monitor,
      workspaces  = screen.workspaces,
      is_physical = true,
    })
  end
else
  local single_screen = screens[1]
  local total_ws = #single_screen.workspaces
  local group_size = 3
  local group_id = 1
  for start_ws = 1, total_ws, group_size do
    local g_ws = {}
    for w = start_ws, math.min(start_ws + group_size - 1, total_ws) do
      table.insert(g_ws, w)
    end
    table.insert(screen_groups, {
      id          = group_id,
      name        = single_screen.name .. " (Grupo " .. group_id .. ")",
      monitor     = single_screen.monitor,
      workspaces  = g_ws,
      is_physical = false,
    })
    group_id = group_id + 1
  end
end

-- Estado ativo
local current_screen = 1
local last_workspace = {}
for i, group in ipairs(screen_groups) do
  last_workspace[i] = group.workspaces[1] or 1
end

-- Identifica a qual grupo/tela um workspace pertence
local function get_group_for_ws(ws)
  for _, group in ipairs(screen_groups) do
    for _, w in ipairs(group.workspaces) do
      if w == ws then
        return group
      end
    end
  end
  return screen_groups[1]
end

-- Funções de navegação de Telas
local function focus_screen(group_id)
  local group = screen_groups[group_id]
  if not group then return end
  current_screen = group_id

  if group.is_physical and connected_set[group.monitor] then
    -- Modo Multi-monitor: foca o monitor físico
    hl.dispatch(hl.dsp.focus({ monitor = group.monitor }))
  else
    -- Modo Tela Única: foca o último workspace ativo desta Tela Virtual
    local target_ws = last_workspace[group_id] or group.workspaces[1]
    hl.dispatch(hl.dsp.focus({ workspace = tostring(target_ws) }))

    -- Feedback visual discreto no topo
    local ws_str = table.concat(group.workspaces, ", ")
    local notify_cmd = string.format(
      "notify-send -t 1200 -h string:x-canonical-private-synchronous:vscreen '🖥️ Tela Virtual %d: %s' 'Workspaces: %s'",
      group.id, group.name, ws_str
    )
    hl.exec_cmd(notify_cmd)
  end
end

local function cycle_screen(direction)
  local next_id = current_screen + direction
  if next_id > #screen_groups then next_id = 1 end
  if next_id < 1 then next_id = #screen_groups end
  focus_screen(next_id)
end

-- =============================================================================
-- 3. Keybinds para Workspaces Diretos (SUPER + 1..N)
-- =============================================================================
local bound_workspaces = {}

for _, screen in ipairs(screens) do
  for _, ws in ipairs(screen.workspaces) do
    bound_workspaces[ws] = true
    local key = tostring(ws)

    -- Abrir workspace (e atualizar a Tela Virtual ativa)
    hl.bind("SUPER + " .. key, function()
      local group = get_group_for_ws(ws)
      if group then
        current_screen = group.id
        last_workspace[group.id] = ws
      end
      hl.dispatch(hl.dsp.focus({ workspace = tostring(ws) }))
    end, { description = "Abrir workspace " .. ws .. " (" .. screen.name .. ")" })

    -- Mover janela ativa para o workspace
    hl.bind("SUPER + SHIFT + " .. key, function()
      local group = get_group_for_ws(ws)
      if group then
        last_workspace[group.id] = ws
      end
      hl.dispatch(hl.dsp.window.move({ workspace = tostring(ws) }))
    end, { description = "Mover janela para workspace " .. ws })

    -- Mover todas as janelas do workspace atual para o workspace alvo
    hl.bind("SUPER + CTRL + " .. key, hl.dsp.exec_raw(HYPRSCRIPTS .. "/moveTo.sh " .. ws), {
      description = "Mover todas as janelas para workspace " .. ws,
    })
  end
end

-- Fallback para garantir que atalhos 1 a 9 sempre existam
for ws = 1, 9 do
  if not bound_workspaces[ws] then
    local key = tostring(ws)
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = tostring(ws) }), {
      description = "Abrir workspace " .. ws,
    })
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(ws) }), {
      description = "Mover janela para workspace " .. ws,
    })
  end
end

-- =============================================================================
-- 4. Keybinds para Telas Físicas / Virtuais
-- =============================================================================
for g_idx, group in ipairs(screen_groups) do
  local s_key = tostring(g_idx)

  -- Focar Tela (SUPER + ALT + 1/2/3...)
  hl.bind("SUPER + ALT + " .. s_key, function()
    focus_screen(g_idx)
  end, { description = "Focar Tela " .. s_key .. " (" .. group.name .. ")" })

  -- Focar Tela (SUPER + F1/F2/F3...)
  hl.bind("SUPER + F" .. s_key, function()
    focus_screen(g_idx)
  end, { description = "Focar Tela " .. s_key .. " (" .. group.name .. ")" })

  -- Mover janela para a Tela (SUPER + ALT + SHIFT + 1/2/3...)
  hl.bind("SUPER + ALT + SHIFT + " .. s_key, function()
    local target_ws = last_workspace[g_idx] or group.workspaces[1]
    hl.dispatch(hl.dsp.window.move({ workspace = tostring(target_ws) }))
    local notify_cmd = string.format(
      "notify-send -t 1200 -h string:x-canonical-private-synchronous:vscreen 'Janela movida' 'Movida para %s (Workspace %d)'",
      group.name, target_ws
    )
    hl.exec_cmd(notify_cmd)
  end, { description = "Mover janela para Tela " .. s_key })
end

-- Ciclar Telas (SUPER + [ / ])
hl.bind("SUPER + bracketleft",  function() cycle_screen(-1) end, { description = "Tela anterior" })
hl.bind("SUPER + bracketright", function() cycle_screen(1) end,  { description = "Próxima Tela" })

-- =============================================================================
-- 5. Navegação Sequencial de Workspaces e Scroll
-- =============================================================================
hl.bind("SUPER + Tab",         hl.dsp.focus({ workspace = "m+1" }), { description = "Próximo workspace" })
hl.bind("SUPER + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }), { description = "Workspace anterior" })

hl.bind("SUPER + mouse_down",  hl.dsp.focus({ workspace = "e+1" }), { description = "Próximo workspace (scroll)" })
hl.bind("SUPER + mouse_up",    hl.dsp.focus({ workspace = "e-1" }), { description = "Workspace anterior (scroll)" })

hl.bind("SUPER + CTRL + down", hl.dsp.focus({ workspace = "empty" }), { description = "Workspace vazio" })
