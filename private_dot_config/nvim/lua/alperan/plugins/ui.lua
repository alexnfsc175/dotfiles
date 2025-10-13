return {
	-- Tema (um dos mais populares)
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false, -- Carrega na inicialização
	-- 	priority = 1000, -- Garante que seja carregado antes de outros plugins
	-- 	config = function()
	-- 		-- Carrega o tema
	-- 		vim.cmd.colorscheme("tokyonight")
	-- 	end,
	-- },

	-- {
	-- 	"navarasu/onedark.nvim",
	-- 	priority = 1000, -- make sure to load this before all the other start plugins
	-- 	config = require("alperan.config.onedark").config,
	-- },

	{
		"olimorris/onedarkpro.nvim",
		priority = 1000, -- Ensure it loads first
		-- config = require("alperan.config.onedarkpro").config,
	},

	-- Barra de status bonita e funcional
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = require("alperan.config.lualine").config,
	},

	-- Barra de Buffers (estilo abas)
	{
		"akinsho/bufferline.nvim",
		version = "*", -- Pega a versão mais recente
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- Dependência para os ícones
		config = require("alperan.config.bufferline").config,
	},

	-- Explorador de arquivos
	-- {
	-- 	"nvim-tree/nvim-tree.lua",
	-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- 	config = require("alperan.config.nvimtree").config,
	-- },
	{
		"nvim-neo-tree/neo-tree.nvim",
		event = "VeryLazy",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			--	"3rd/image.nvim",
			{
				"s1n7ax/nvim-window-picker",
				version = "2.*",
				config = function()
					require("window-picker").setup({
						filter_rules = {
							include_current_win = false,
							autoselect_one = true,
							-- filter using buffer options
							bo = {
								-- if the file type is one of following, the window will be ignored
								filetype = { "neo-tree", "neo-tree-popup", "notify" },
								-- if the buffer type is one of following, the window will be ignored
								buftype = { "terminal", "quickfix" },
							},
						},
					})
				end,
				keys = {
					{ "<leader>w", ":Neotree toggle float<CR>", silent = true, desc = "Float File Explorer" },
					{ "<leader>e", ":Neotree toggle position=left<CR>", silent = true, desc = "Left File Explorer" },
					{
						"<leader>ngs",
						":Neotree float git_status<CR>",
						silent = true,
						desc = "Neotree Open Git Status Window",
					},
				},
			},
		},
		config = require("alperan.config.neo-tree").config,
	},

	{
		"nvimdev/dashboard-nvim",
		lazy = false, -- load immediately
		priority = 1001, -- after colorscheme (1000), before the rest
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = require("alperan.config.dashboard-nvim").config,
	},
}
