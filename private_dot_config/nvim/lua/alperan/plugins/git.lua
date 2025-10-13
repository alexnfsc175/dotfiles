return {
	{
		"lewis6991/gitsigns.nvim",
		config = require("alperan.config.gitsigns"),
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- Optional: Configuration for lazygit.nvim
		config = function()
			-- No specific config needed for now
		end,
	},
}
