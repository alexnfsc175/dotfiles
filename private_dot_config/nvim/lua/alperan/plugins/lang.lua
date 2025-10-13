return {
	-- Treesitter para melhor highlighting, indentação e mais
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = require("alperan.config.treesitter").config,
	},
}

