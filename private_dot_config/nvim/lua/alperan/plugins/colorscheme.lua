-- local M = {}

-- M.DARK_THEME = "onedark_vivid"
-- M.LIGHT_THEME = "onelight"

-- -- This gets called on startup after `onedarkpro.nvim` loads
-- M.setup = function()
--   vim.api.nvim_create_autocmd("OptionSet", {
--     pattern = "background",
--     callback = function(_)
--       vim.cmd.colorscheme(vim.o.background == "light" and M.LIGHT_THEME or M.DARK_THEME)
--     end,
--   })
-- end

-- return M