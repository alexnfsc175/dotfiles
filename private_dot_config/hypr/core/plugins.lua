-- Plugin System
-- Carrega e gerencia plugins para Hyprland

local M = {}

-- Configuração de plugins
M.config = {
  -- Diretório de plugins
  plugins_dir = os.getenv("HOME") .. "/.config/hypr/plugins",
  
  -- Plugins habilitados
  enabled = {
    "opacity",
    "wallpaper",
  },
}

-- Carregar plugin
function M.load_plugin(name)
  local plugin_path = M.config.plugins_dir .. "/" .. name .. ".lua"
  local plugin = dofile(plugin_path)
  if plugin and plugin.init then
    plugin.init()
  end
  return plugin
end

-- Carregar todos os plugins habilitados
function M.load_all()
  for _, name in ipairs(M.config.enabled) do
    local ok, plugin = pcall(M.load_plugin, name)
    if not ok then
      -- Plugin não encontrado ou erro, continua
    end
  end
end

-- Registrar plugin
function M.register(name, plugin)
  M.plugins = M.plugins or {}
  M.plugins[name] = plugin
end

-- Obter plugin
function M.get(name)
  M.plugins = M.plugins or {}
  return M.plugins[name]
end

-- Inicializar sistema de plugins
function M.init()
  M.plugins = {}
  M.load_all()
end

return M
