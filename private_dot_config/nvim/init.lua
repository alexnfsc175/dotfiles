local namespace = "alperan"

require(namespace .. ".core")
require(namespace .. ".lazy")

local status, _ = pcall(require, "current-theme")
if not status then
	vim.cmd("colorscheme onedark_vivid")
end

-- Remove as linhas verticais que podem aparecer em alguns temas/plugins (como o dashboard)
-- vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
