-- Configuração do Telescope para o Neovim
--- @module 'alperan.config.telescope'

local BaseConfig = require("alperan.config.base-config")
local Telescope = BaseConfig.new()

--- Configura o Telescope para o Neovim.
---
---@return nil
function Telescope.config()
    -- Importa o módulo Telescope e as ações
    local telescope = Telescope:require_once("telescope")
    local actions = Telescope:require_once("telescope.actions")


    telescope.setup({
        defaults = {
        -- Mapeamento para fechar o Telescope no modo de inserção
        mappings = {
            i = {
            ["<C-q>"] = actions.close,
            },
        },
        },
        extensions = {
        fzf = {
            fuzzy = true, -- Ativa o algoritmo fuzzy
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
        },
    })

    -- Carrega a extensão fzf-native que instalamos
    telescope.load_extension("fzf")
end

return Telescope







-- Configuração do Telescope
-- return function()
--   -- Importa o módulo Telescope e as ações
--   local telescope = require("telescope")
--   local actions = require("telescope.actions")

--   telescope.setup({
--     defaults = {
--       -- Mapeamento para fechar o Telescope no modo de inserção
--       mappings = {
--         i = {
--           ["<C-q>"] = actions.close,
--         },
--       },
--     },
--     extensions = {
--       fzf = {
--         fuzzy = true, -- Ativa o algoritmo fuzzy
--         override_generic_sorter = true,
--         override_file_sorter = true,
--         case_mode = "smart_case",
--       },
--     },
--   })

--   -- Carrega a extensão fzf-native que instalamos
--   telescope.load_extension("fzf")
-- end