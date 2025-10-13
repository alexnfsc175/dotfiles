--- Configuração do nvim-autopairs
--- @module 'alperan.config.autopairs'

local BaseConfig = require("alperan.config.base-config")
local AutoPairs = BaseConfig.new()

---@class AutoPairs.Options
---@field cmp_integration boolean|nil Se deve integrar com o nvim-cmp (verdadeiro por padrao).

--- Configura o nvim-autopairs com as opções fornecidas.
---
---@param opts AutoPairs.Options
---
---@return nil
function AutoPairs.config(opts)
	local autopairs = AutoPairs:require_once("nvim-autopairs")
	opts = opts or {}

	autopairs.setup({
		check_ts = true, -- Habilita a verificação da árvore de sintaxe
		ts_config = {
			lua = { "string" }, -- Lua
			javascript = { "template_string" }, -- JavaScript
			java = false, -- Java
		},
	})

	if opts.cmp_integration ~= false then
		local cmp = AutoPairs:require_once("cmp")
		local cmp_autopairs = AutoPairs:require_once("nvim-autopairs.completion.cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end
end


--- Configura o nvim-autopairs com opções padrão.
---
---@param opts AutoPairs.Options
---
---@return function
--- Uma função que chama a configuração com as opções padrão.
function AutoPairs.setup(opts)
	return function()
		AutoPairs:config(opts or {})
	end
end

return AutoPairs
