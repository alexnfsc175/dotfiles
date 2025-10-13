--- Configuração do dashboard-nvim para o Neovim
--- @module 'alperan.config.dashboard-nvim'

local BaseConfig = require("alperan.config.base-config")
local Dashboard = BaseConfig.new()

--- Configura o Dashboard para o Neovim.
---
---@return nil
function Dashboard.config()
	local dashboard = Dashboard:require_once("dashboard")

	dashboard.setup({
		theme = "doom",
		config = {
			header = {
				"                                                                       ",
				"                                                                       ",
				"                                                                     ",
				"       ████ ██████           █████      ██                     ",
				"      ███████████             █████                             ",
				"      █████████ ███████████████████ ███   ███████████   ",
				"     █████████  ███    █████████████ █████ ██████████████   ",
				"    █████████ ██████████ █████████ █████ █████ ████ █████   ",
				"  ███████████ ███    ███ █████████ █████ █████ ████ █████  ",
				" ██████  █████████████████████ ████ █████ █████ ████ ██████ ",
				"                                                                       ",
				"                                                                       ",
			},
			center = {
				{ desc = "  Find File           ", action = "Telescope find_files" },
				{ desc = "  Live Grep           ", action = "Telescope live_grep" },
				{ desc = "  File Explorer       ", action = "NvimTreeToggle" },
				{ desc = "  Git Branches        ", action = "Telescope git_branches" },
				{ desc = "  Quit                ", action = "qa" },
			},
		},
	})
end

return Dashboard

