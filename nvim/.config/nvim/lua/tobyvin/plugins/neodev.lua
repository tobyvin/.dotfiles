local M = {
	"folke/neodev.nvim",
	version = "*",
	opts = {
		experimental = {
			pathStrict = true,
		},
		override = function(root_dir, library)
			if root_dir:match("dotfiles") then
				library.enabled = true
				library.plugins = true
			end
		end,
	},
}

return M
