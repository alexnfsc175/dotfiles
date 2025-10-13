--- Configuração do l ualine para o Neovim
--- @module 'alperan.config.lualine'

local BaseConfig = require("alperan.config.base-config")
local LuaLine = BaseConfig.new()

--- Configura o lualine
---
---@return nil
function LuaLine.config()
	local lualine = LuaLine:require_once("lualine")

	local function hide_in_width(width)
		return function()
			return vim.fn.winwidth(0) > width
		end
	end

	-- https://github.com/nvim-lualine/lualine.nvim/blob/master/examples/slanted-gaps.lua
	-- https://github.com/nvim-lualine/lualine.nvim/discussions/911
	--
	local colors = {
		red = "#ca1243",
		grey = "#a0a1a7",
		black = "#383a42",
		white = "#f3f3f3",
		light_green = "#83a598",
		orange = "#fe8019",
		green = "#8ec07c",
	}

	local function diff_source()
		local gitsigns = vim.b.gitsigns_status_dict
		if gitsigns then
			return {
				added = gitsigns.added,
				modified = gitsigns.changed,
				removed = gitsigns.removed,
			}
		end
	end

	local mode = {
		"mode",
		-- fmt = function(str)
		-- 	-- return ' ' .. str:sub(1, 1) -- displays only the first character of the mode
		-- 	return " " .. str
		-- end,
		-- icon = "",
		icon = { "", align = "left", color = { gui = "bold" } },
	}

	local diff = {
		"diff",
		colored = true,
		symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
		cond = hide_in_width(80),
		source = diff_source,
		padding = { left = 1, right = 1 },
	}

	local filetype = {
		"filetype",
		icons_enabled = true,
		padding = { left = 1, right = 0 },
	}

	local fileformat = {
		"fileformat",
		icons_enabled = true,
		symbols = {
			unix = "LF",
			dos = "CRLF",
			mac = "CR",
		},
		cond = hide_in_width(120),
	}

	local time = {
		'os.date("%H:%M:%S", os.time())',
	}

	local spaces = {
		function()
			return "sw-" .. vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
		end,
		separator = { left = "" },
		cond = hide_in_width(120),
	}

	local diagnostics_message = require("alperan.config.lualine-diagnostics-message")

	local diags_msg = {
		diagnostics_message,
		colors = {
			error = "#BF616A",
			warn = "#EBCB8B",
			info = "#A3BE8C",
			hint = "#88C0D0",
		},
		cond = diagnostics_message.has_diags_msg,
	}

	local diags_error = {
		"diagnostics",
		source = { "nvim" },
		sections = { "error" },
		diagnostics_color = { error = { bg = colors.red, fg = colors.white } },
		separator = { right = "" },
	}

	local diags_warn = {
		"diagnostics",
		source = { "nvim" },
		sections = { "warn" },
		diagnostics_color = { warn = { bg = colors.orange, fg = colors.white } },
		separator = { right = "" },
	}

	local filename = {
		"filename",
		file_status = true, -- Displays file status (readonly status, modified status)
		newfile_status = true, -- Display new file status (new file means no write after created)
		path = 3,
		-- 0: Just the filename
		-- 1: Relative path
		-- 2: Absolute path
		-- 3: Absolute path, with tilde as the home directory
		shorting_target = 40, -- Shortens path to leave 40 spaces in the window
		-- for other components. (terrible name, any suggestions?)
		symbols = {
			modified = "[+]", -- Text to show when the file is modified.
			readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
			unnamed = "", -- Text to show for unnamed buffers.
			newfile = "", -- Text to show for newly created file before first write
		},
		cond = function()
			return not diagnostics_message.has_diags_msg()
		end,
	}

	local encoding = {
		"encoding",
		padding = 0,
		cond = function()
			local encoding = vim.opt.fileencoding:get()
			if encoding == "utf-8" then
				return false
			end
			return hide_in_width(120)
		end,
	}

	local search_result = {
		function()
			if vim.v.hlsearch == 0 then
				return ""
			end
			local last_search = vim.fn.getreg("/")
			if not last_search or last_search == "" then
				return ""
			end
			local searchcount = vim.fn.searchcount({ maxcount = 9999 })
			return last_search .. "(" .. searchcount.current .. "/" .. searchcount.total .. ")"
		end,
		color = "Search",
		separator = { left = "" },
	}

	local location = {
		"%l:%c %p%% %L",
	}

	local lsp_status = {
		"lsp_status",
		icon = "", -- f013
		symbols = {
			-- Standard unicode symbols to cycle through for LSP progress:
			spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
			-- Standard unicode symbol for when LSP is done:
			done = "✓",
			-- Delimiter inserted between LSP names:
			separator = " ",
		},
		-- List of LSP names to ignore (e.g., `null-ls`):
		ignore_lsp = {},
	}
	---

	lualine.setup({
		options = {
			globalstatus = true,
			icons_enabled = true,
			theme = "auto",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			-- section_separators = { left = "", right = "" },
			-- component_separators = { left = '', right = '' }
			-- section_separators = { left = '', right = '' },
			-- component_separators = { left = '', right = ''},
			-- section_separators = { left = '', right = ''},

			-- Some useful glyphs:
			-- https://www.nerdfonts.com/cheat-sheet
			--        
			-- section_separators = { left = "", right = "" },
			-- component_separators = { left = "  ", right = "  " },

			disabled_filetypes = { "alpha", "dashboard", "neo-tree" },
			always_divide_middle = true,
		},
		sections = {
			lualine_a = { mode },
			lualine_b = { "branch", diff },
			lualine_c = { diags_error, diags_warn, filename, diags_msg },
			lualine_x = { search_result, lsp_status, spaces, encoding, fileformat },
			lualine_y = { filetype, time },
			lualine_z = { location },
		},
		--
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {},
	})
end

return LuaLine
