--- Configuração do tmux para o Neovim
--- @module 'alperan.config.tmux'

local BaseConfig = require("alperan.config.base-config")
local Tmux = BaseConfig.new()

--- Configura o Tmux para o Neovim.
---
---@return nil
function Tmux.setup()
  		vim.g.tmux_navigator_no_mappings = 1
			vim.keymap.set('n', '<c-h>', ':<c-u>TmuxNavigateLeft<cr>', {})
			vim.keymap.set('n', '<c-l>', ':<c-u>TmuxNavigateRight<cr>', {})
			vim.keymap.set('n', '<c-j>', ':<c-u>TmuxNavigateDown<cr>', {})
			vim.keymap.set('n', '<c-k>', ':<c-u>TmuxNavigateUp<cr>', {})
      vim.keymap.set('n', '<c-\\>', ':<c-u>TmuxNavigatePrevious<cr>', {})
end

return Tmux