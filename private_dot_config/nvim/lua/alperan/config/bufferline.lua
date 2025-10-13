--- Configuração do bufferline para o Neovim
--- @module 'alperan.config.bufferline'

local BaseConfig = require("alperan.config.base-config")
local Bufferline = BaseConfig.new()

--- Configura o bufferline
---
---@return nil
function Bufferline.config()
	local bufferline = Bufferline:require_once("bufferline")
	bufferline.setup({
		options = {
			-- Mostra os ícones de tipo de arquivo
			show_buffer_icons = true,
			show_buffer_close_icons = true,
			show_close_icon = true,
			-- Adiciona um espaço à esquerda se o nvim-tree estiver aberto
			offsets = {
				{
					filetype = "NvimTree",
					text = "Explorador de Arquivos",
					text_align = "left",
					separator = false, -- Adiciona um separador
					padding = 0,
				},
			},
			separator_style = { "", "" },
			mode = "buffers", -- set to "tabs" to only show tabpages instead
			style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
			close_command = "bdelete! %d", -- can be a string | function, | false see "Mouse actions"
			right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
			left_mouse_command = "buffer %d", -- can be a string | function, | false see "Mouse actions"
			middle_mouse_command = nil, -- can be a string | function, | false see "Mouse actions"
			indicator = {
				icon = "▎", -- this should be omitted if indicator style is not 'icon'
				style = "icon", -- | "underline" | "none",
			},
			buffer_close_icon = "󰅖",
			modified_icon = "● ",
			close_icon = " ",
			left_trunc_marker = " ",
			right_trunc_marker = " ",
		},
	})

	-- -- BufferLine highlights
	-- vim.cmd("hi BufferLineOffsetSeparator guifg=#589ed7 guibg=None")
	-- vim.cmd("hi BufferLineFill guifg=Red guibg=None")
	-- vim.cmd("hi BufferLineSeparator guifg=#1E1E2E guibg=None")

	-- bufferline
	-- separator
	-- vim.api.nvim_set_hl(0, "BufferlineCustomeNvimtree", { fg = "#959595", bg = "#c2c2c2", bold = true })
	-- vim.api.nvim_set_hl(0, "BufferLineOffsetSeparator", { fg = "#c2c2c2", bg = "#c2c2c2", bold = true })
	-- vim.api.nvim_set_hl(0, "BufferLineSeparator", { fg = "#d5d5d5", bg = "#d5d5d5", bold = true })
	-- -- vim.api.nvim_set_hl(0, "BufferLineSeparator", { fg = "#c2c2c2", bg = "#d5d5d5", bold = true })
	-- vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { fg = "#c2c2c2", bold = true })
	-- vim.api.nvim_set_hl(0, "BufferLineTabSeparator", { fg = "#c2c2c2", bg = "#d5d5d5", bold = true })
	-- vim.api.nvim_set_hl(0, "BufferLineTabSeparatorSelected", { fg = "#c2c2c2", bold = true })
	-- vim.api.nvim_set_hl(0, "BufferLineGroupSeparator", { fg = "#c2c2c2", bg = "#c2c2c2", bold = true })
end

return Bufferline
