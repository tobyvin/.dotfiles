local M = {
	"folke/neodev.nvim",
	event = "BufReadPre",
	opts = {
		override = function(root_dir, library)
			if root_dir:match("dotfiles") then
				library.enabled = true
				library.plugins = true
			end
		end,
	},
}

return M
