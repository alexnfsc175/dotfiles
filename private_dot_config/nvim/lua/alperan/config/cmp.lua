--- Configuração do Treesitter para o Neovim
--- @module 'alperan.config.cmp'

local BaseConfig = require("alperan.config.base-config")
local Cmp = BaseConfig.new()

--- Configura o Cmp
---@return nil
function Cmp.config()
	-- Carrega o módulo nvim-cmp
	local cmp = Cmp:require_once("cmp")
	local luasnip = Cmp:require_once("luasnip")

	-- Configura o nvim-cmp
	cmp.setup({
		snippet = {
			expand = function(args)
				-- Expande o snippet usando luasnip
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<C-Space>"] = cmp.mapping.complete(),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-p>"] = cmp.mapping.select_prev_item(),
		}),
		sources = {
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "buffer" },
			{ name = "path" },
		},
	})
end

return Cmp

