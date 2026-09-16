-- Configuração centralizada de monitores e Telas Virtuais (Single Source of Truth)
-- https://wiki.hypr.land/Configuring/Basics/Monitors

-- =============================================================================
-- 1. Definições e Presets dos Monitores
-- =============================================================================

-- Quantidade de workspaces quando houver apenas 1 monitor conectado (ex: Laptop móvel ou VM QEMU)
local single_monitor_workspaces = 9

-- Presets predefinidos para monitores conhecidos.
-- order:    Ordem física de disposição da esquerda para a direita (1, 2, 3...)
-- mode:     Resolução e taxa de atualização ("1920x1080@60", "2560x1440@60", etc.)
-- scale:    Escala do monitor (1.0, 1.25, etc.)
-- ws_count: Quantidade de workspaces alocados para este monitor em multi-monitor
-- primary:  Preferência de monitor principal quando conectado
local monitor_presets = {
  ["eDP-1"] = {
    name     = "Notebook",
    order    = 1,
    mode     = "1920x1080@60",
    scale    = 1.0,
    ws_count = 3,
    primary  = true,
  },
  ["DP-2"] = {
    name     = "Alienware",
    order    = 2,
    mode     = "2560x1440@60",
    scale    = 1.0,
    ws_count = 3,
    primary  = false,
  },
  ["HDMI-A-1"] = {
    name     = "AOC",
    order    = 3,
    mode     = "1920x1080@60",
    scale    = 1.0,
    ws_count = 3,
    primary  = false,
  },
  ["Virtual-1"] = {
    name     = "VM QEMU",
    order    = 1,
    mode     = "1920x1080@60",
    scale    = 1.0,
    ws_count = 9,
    primary  = true,
  },
}

-- Configuração padrão para monitores desconhecidos (ex: TV, projetor, novo monitor)
local default_preset = {
  name     = "Monitor",
  order    = 99,
  mode     = "preferred",
  scale    = 1.0,
  ws_count = 3,
  primary  = false,
}

-- =============================================================================
-- 2. Detecção Dinâmica via sysfs (/sys/class/drm)
-- =============================================================================

-- Detecta instantaneamente conectores com status 'connected' via kernel sysfs
local function get_connected_connectors()
  local detected = {}
  local seen = {}

  -- Varredura rápida nos conectores drm
  local p = io.popen("for s in /sys/class/drm/card*-*/status; do [ -f \"$s\" ] && grep -q '^connected' \"$s\" 2>/dev/null && basename \"${s%/status}\"; done", "r")
  if p then
    for line in p:lines() do
      local conn = line:match("^card%d+%-(.+)$")
      if conn and not seen[conn] then
        seen[conn] = true
        table.insert(detected, conn)
      end
    end
    p:close()
  end

  -- Fallback direto via io.open caso popen falhe
  if #detected == 0 then
    for conn, _ in pairs(monitor_presets) do
      for _, card in ipairs({ "card0", "card1", "card2" }) do
        local f = io.open("/sys/class/drm/" .. card .. "-" .. conn .. "/status", "r")
        if f then
          local st = f:read("*l")
          f:close()
          if st and st:match("^connected") and not seen[conn] then
            seen[conn] = true
            table.insert(detected, conn)
          end
        end
      end
    end
  end

  -- Fallback de segurança se nada for detectado
  if #detected == 0 then
    table.insert(detected, "eDP-1")
  end

  return detected
end

-- =============================================================================
-- 3. Construção e Posicionamento Dinâmico das Telas Ativas
-- =============================================================================
local function build_screens()
  local connectors = get_connected_connectors()
  local active = {}

  for _, conn in ipairs(connectors) do
    local preset = monitor_presets[conn] or default_preset
    table.insert(active, {
      monitor  = conn,
      name     = preset.name,
      order    = preset.order or 99,
      mode     = preset.mode or "preferred",
      scale    = preset.scale or 1.0,
      ws_count = preset.ws_count or 3,
      primary  = preset.primary or false,
    })
  end

  -- Ordena fisicamente pela ordem definida (esquerda para a direita)
  table.sort(active, function(a, b)
    if a.order ~= b.order then
      return a.order < b.order
    end
    return a.monitor < b.monitor
  end)

  -- Garante a existência de um monitor primário
  local has_primary = false
  for _, s in ipairs(active) do
    if s.primary then
      has_primary = true
      break
    end
  end
  if not has_primary and active[1] then
    active[1].primary = true
  end

  -- Atribui IDs sequenciais (1, 2, 3...)
  for i, s in ipairs(active) do
    s.id = i
  end

  -- Distribuição de Workspaces e cálculo de posicionamento contíguo
  if #active == 1 then
    -- Modo Tela Única: monitor ativo recebe todos os workspaces configurados
    active[1].position = "0x0"
    local ws_list = {}
    for w = 1, single_monitor_workspaces do
      table.insert(ws_list, w)
    end
    active[1].workspaces = ws_list
  else
    -- Modo Multi-monitor: blocos sequenciais de workspaces por tela
    local current_ws = 1
    local current_x = 0
    for _, s in ipairs(active) do
      local ws_list = {}
      for _ = 1, s.ws_count do
        table.insert(ws_list, current_ws)
        current_ws = current_ws + 1
      end
      s.workspaces = ws_list

      s.position = string.format("%dx0", current_x)
      local width = tonumber(s.mode:match("^(%d+)x"))
      if not width then
        for _, card in ipairs({ "card0", "card1", "card2" }) do
          local mf = io.open("/sys/class/drm/" .. card .. "-" .. s.monitor .. "/modes", "r")
          if mf then
            local mline = mf:read("*l")
            mf:close()
            if mline then
              width = tonumber(mline:match("^(%d+)x"))
              if width then break end
            end
          end
        end
      end
      width = width or 1920
      current_x = current_x + math.floor(width / (s.scale or 1.0))
    end
  end

  return active
end

-- Lista final de telas ativas e resolvidas
local screens = build_screens()

-- Retorna o nome do monitor principal
local function get_primary_monitor()
  for _, s in ipairs(screens) do
    if s.primary then
      return s.monitor
    end
  end
  return screens[1] and screens[1].monitor or "eDP-1"
end

-- Conjunto com chave para checagem rápida (ex: set["eDP-1"] == true)
local function get_connected_set()
  local set = {}
  for _, s in ipairs(screens) do
    set[s.monitor] = true
  end
  return set
end

-- Verifica se há múltiplos monitores ou monitor externo conectado
local function is_docked()
  if #screens > 1 then
    return true
  end
  for _, s in ipairs(screens) do
    if s.monitor ~= "eDP-1" and s.monitor ~= "Virtual-1" then
      return true
    end
  end
  return false
end

-- Lista com os nomes dos monitores conectados
local monitor_names = {}
for _, s in ipairs(screens) do
  table.insert(monitor_names, s.monitor)
end

-- Função para consultar monitores dinamicamente via Hyprland IPC (após boot completo)
local function get_monitors()
  local handle = io.popen("hyprctl -j monitors 2>/dev/null | jq -r 'sort_by(.id) | .[] | (.id|tostring) + \" \" + .name'")
  if not handle then return { get_primary_monitor() } end

  local result = handle:read("*a")
  handle:close()

  local monitors = {}
  for line in result:gmatch("[^\n]+") do
    local name = line:match("^%d+ (.+)$")
    if name then
      table.insert(monitors, name)
    end
  end

  return #monitors > 0 and monitors or { get_primary_monitor() }
end

return {
  single_monitor_workspaces = single_monitor_workspaces,
  monitor_presets           = monitor_presets,
  default_preset            = default_preset,
  screens                   = screens,
  monitors                  = monitor_names,
  ws_per_monitor            = 3,
  get_primary_monitor       = get_primary_monitor,
  get_monitors              = get_monitors,
  get_connected_set         = get_connected_set,
  is_docked                 = is_docked,
  build_screens             = build_screens,
}
