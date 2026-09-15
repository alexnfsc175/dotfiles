-- Configuração centralizada de monitores e Telas Virtuais (Single Source of Truth)
-- https://wiki.hypr.land/Configuring/Basics/Monitors

-- Definição única de todas as telas, monitores físicos, posições e workspaces correspondentes.
-- Para adicionar, remover ou reordenar monitores, basta editar esta lista!
local screens = {
  {
    id         = 1,
    name       = "Notebook",
    monitor    = "eDP-1",
    primary    = true,            -- Monitor principal do sistema / tela do laptop
    mode       = "1920x1080@60",
    position   = "0x0",
    scale      = 1.0,
    workspaces = { 1, 2, 3 },
  },
  {
    id         = 2,
    name       = "Alienware",
    monitor    = "DP-2",
    primary    = false,
    mode       = "2560x1440@60",
    position   = "1920x0",
    scale      = 1.0,
    workspaces = { 4, 5, 6 },
  },
  {
    id         = 3,
    name       = "AOC",
    monitor    = "HDMI-A-1",
    primary    = false,
    mode       = "1920x1080@60",
    position   = "4480x0",
    scale      = 1.0,
    workspaces = { 7, 8, 9 },
  },
}

-- Retorna o nome do monitor principal (ou fallback para a 1ª tela da lista)
local function get_primary_monitor()
  for _, s in ipairs(screens) do
    if s.primary then
      return s.monitor
    end
  end
  return screens[1] and screens[1].monitor or "eDP-1"
end

-- Detecção segura via sysfs do Linux (instantâneo, leitura direta de arquivo, zero IPC com Hyprland)
local function get_connected_set()
  local set = { [get_primary_monitor()] = true }
  for _, s in ipairs(screens) do
    if not s.primary then
      local f = io.popen("grep -s '^connected' /sys/class/drm/*-" .. s.monitor .. "/status 2>/dev/null")
      if f then
        local res = f:read("*a")
        f:close()
        if res and res:find("connected") then
          set[s.monitor] = true
        end
      end
    end
  end
  return set
end

-- Verifica se há algum monitor externo conectado
local function is_docked()
  local set = get_connected_set()
  for _, s in ipairs(screens) do
    if not s.primary and set[s.monitor] then
      return true
    end
  end
  return false
end

-- Lista com os nomes dos monitores (para compatibilidade)
local monitor_names = {}
for _, s in ipairs(screens) do
  table.insert(monitor_names, s.monitor)
end

-- Função para detectar monitores dinamicamente (chamar apenas depois do startup completo)
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
  screens              = screens,
  monitors             = monitor_names,
  ws_per_monitor       = 3,
  get_primary_monitor  = get_primary_monitor,
  get_monitors         = get_monitors,
  get_connected_set    = get_connected_set,
  is_docked            = is_docked,
}
