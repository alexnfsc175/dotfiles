--- Treesitter para melhor highlighting, indentação e mais
--- @module 'alperan.config.treesitter'

local BaseConfig = require("alperan.config.base-config")
local Treesitter = BaseConfig.new()

--- Configura o Treesitter
---@return nil
function Treesitter.config()
  -- Carrega o módulo nvim-treesitter
  local nvim_treesitter = Treesitter:require_once("nvim-treesitter.configs")
  -- Configura o nvim-treesitter
  nvim_treesitter.setup({
    -- Linguagens a serem instaladas
    ensure_installed = {
      "c", "lua", "vim", "vimdoc", "query",
      "javascript", "typescript", "html", "css", "json", "yaml",
      "markdown", "bash", "dockerfile",
    },
    -- Instalação síncrona
    sync_install = false,
    -- Instala automaticamente as linguagens
    auto_install = true,
    -- Habilita o highlighting
    highlight = {
      enable = true,
    },
    -- Habilita a indentação automática
    indent = {
      enable = true,
    },
    -- Habilita o folding baseado em Treesitter
    fold = {
      enable = true,
    },
  })
end

return Treesitter


-- return function()
--   require("nvim-treesitter.configs").setup({
--     ensure_installed = {
--       "c", "lua", "vim", "vimdoc", "query",
--       "javascript", "typescript", "html", "css", "json", "yaml", "markdown", "bash", "dockerfile",
--     },
--     sync_install = false,
--     auto_install = true,
--     highlight = { enable = true },
--     indent = { enable = true },
--   })
-- end

