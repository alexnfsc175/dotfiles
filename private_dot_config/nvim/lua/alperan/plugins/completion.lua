return { -- Autocompletar
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip", -- Dependência para snippets
			"saadparwaiz1/cmp_luasnip",
		},
		config = require("alperan.config.cmp").config,
	},
}

