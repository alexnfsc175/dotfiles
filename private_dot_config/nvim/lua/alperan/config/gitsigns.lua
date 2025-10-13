--- Configuracoes do gitsigns
--- @module 'alperan.config.gitsigns'

local BaseConfig = require("alperan.config.base-config")
local GitSigns = BaseConfig.new()

function GitSigns.config()
	local gitsigns = GitSigns:require_once("gitsigns")

	--- @type Gitsigns.Config
	local opts = {}
	gitsigns.setup(opts)
end

return GitSigns
