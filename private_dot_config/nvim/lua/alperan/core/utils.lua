local M = {}
-- https://github.com/LuaLS/lua-language-server/wiki/Annotations

---@class Options
---@field filetype string The filetype of the buffer

--- Retorna a largura da janela do nvim-tree se estiver aberta, caso contrário 0.
---
---@param opts Options
---
---@return number
M.get_nvim_tree_width = function(opts)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		-- Verificamos o 'filetype' do buffer dentro de cada janela
		if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "NvimTree" then
			return vim.api.nvim_win_get_width(win)
		end
	end
	return 0 -- Retorna 0 se nvim-tree não estiver aberto
end

M.toggle_relative_number = function()
	if vim.wo.number == false then
		-- OFF -> ABSOLUTE
		vim.wo.number = true
		vim.wo.relativenumber = false
	elseif vim.wo.relativenumber == false then
		-- ABSOLUTE -> RELATIVE
		vim.wo.relativenumber = true
	else
		-- RELATIVE -> OFF
		vim.wo.number = false
		vim.wo.relativenumber = false
	end
end

return M
