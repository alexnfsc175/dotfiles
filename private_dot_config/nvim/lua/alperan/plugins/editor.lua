return {
	-- Comentários fáceis com `gcc`
	"numToStr/Comment.nvim",

	-- Pares de (), [], {} automáticos
	{
		"windwp/nvim-autopairs",
		dependencies = {
			"nvim-cmp",
		},
		config = require("alperan.config.autopairs").config,
	},

	-- Identação visual
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = require("alperan.config.indent-blankline").config,
	},
}
