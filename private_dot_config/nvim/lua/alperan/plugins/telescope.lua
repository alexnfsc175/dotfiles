-- nvim/lua/plugins/telescope.lua

return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			-- Dependência obrigatória do Telescope
			"nvim-lua/plenary.nvim",

			-- Melhora a performance da ordenação/preview, opcional mas recomendado
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = require("alperan.config.telescope").config,
	},
}

