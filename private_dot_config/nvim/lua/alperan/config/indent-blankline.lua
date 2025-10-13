---@module 'alperan.config.ident-blankline'

local BaseConfig = require("alperan.config.base-config")
local IdentBlankLine = BaseConfig.new()

function IdentBlankLine.config()
	local ibl = IdentBlankLine:require_once("ibl")

	---@type ibl.config
	local opts = {
		exclude = {
			filetypes = {
				"dashboard",
			},
		},
		scope = {
			show_start = false,
			show_end = false,
		},
		indent = {
			highlight = "IblIndent",
			char = "▏",
			-- char = "┊",
			-- char = "¦",
			-- char = "⎸",
			-- char = "│",
		},
	}

	ibl.setup(opts)
end

return IdentBlankLine
