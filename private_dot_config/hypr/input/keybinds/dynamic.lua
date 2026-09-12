-- Dynamic Keybind Generation
-- Gera keybinds baseados em configuração e contexto

local M = {}

-- Configuração de keybinds
M.config = {
  -- Modificador principal
  main_mod = "SUPER",
  
  -- Atalhos por categoria
  categories = {
    apps = {
      terminal = { key = "RETURN", desc = "Abrir terminal" },
      browser = { key = "B", desc = "Abrir browser" },
      file_manager = { key = "E", desc = "Abrir gerenciador de arquivos" },
      launcher = { key = "CTRL + RETURN", desc = "Abrir application launcher" },
    },
    windows = {
      close = { key = "Q", desc = "Fechar janela" },
      kill = { key = "SHIFT + Q", desc = "Encerrar janela" },
      fullscreen = { key = "F", desc = "Fullscreen" },
      maximize = { key = "M", desc = "Maximizar janela" },
      float = { key = "T", desc = "Toggle floating" },
    },
    workspaces = {
      next = { key = "Tab", desc = "Próximo workspace" },
      prev = { key = "SHIFT + Tab", desc = "Workspace anterior" },
      empty = { key = "CTRL + down", desc = "Workspace vazio" },
    },
    system = {
      reload = { key = "CTRL + R", desc = "Recarregar configuração" },
      screenshot = { key = "SHIFT + S", desc = "Tirar screenshot" },
      powermenu = { key = "CTRL + Q", desc = "Abrir powermenu" },
      theme = { key = "CTRL + T", desc = "Alternar tema" },
    },
  },
}

-- Gerar keybind para workspace
function M.generate_workspace_binds(monitors, ws_per_monitor)
  local binds = {}
  
  for i, monitor in ipairs(monitors) do
    for j = 1, ws_per_monitor do
      local ws = (i - 1) * ws_per_monitor + j
      local key = tostring(ws)
      
      -- Trocar para workspace
      table.insert(binds, {
        key = M.config.main_mod .. " + " .. key,
        action = hl.dsp.focus({ workspace = tostring(ws) }),
        desc = "Abrir workspace " .. ws,
      })
      
      -- Mover janela para workspace
      table.insert(binds, {
        key = M.config.main_mod .. " + SHIFT + " .. key,
        action = hl.dsp.window.move({ workspace = tostring(ws) }),
        desc = "Mover janela para workspace " .. ws,
      })
    end
  end
  
  return binds
end

-- Gerar keybind para aplicativo
function M.generate_app_bind(app_name, cmd)
  local app_config = M.config.categories.apps[app_name]
  if not app_config then return nil end
  
  return {
    key = M.config.main_mod .. " + " .. app_config.key,
    action = hl.dsp.exec_raw(cmd),
    desc = app_config.desc,
  }
end

-- Aplicar keybinds gerados
function M.apply_binds(binds)
  for _, bind in ipairs(binds) do
    hl.bind(bind.key, bind.action, { description = bind.desc })
  end
end

-- Inicializar keybinds dinâmicos
function M.init()
  -- Carregar configuração de monitores
  local config = require("core.config")
  local monitors = config.monitors
  local ws_per_monitor = config.ws_per_monitor
  
  -- Gerar e aplicar keybinds de workspace
  local workspace_binds = M.generate_workspace_binds(monitors, ws_per_monitor)
  M.apply_binds(workspace_binds)
end

return M
