local M = {
	"folke/neodev.nvim",
}

function M.config()
	local neodev = require("neodev")

	neodev.setup({
		library = {
			enabled = true,
			runtime = true,
			types = true,
			plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
		},
		override = function(root_dir, library)
			local lua_dev_utils = require("lua-dev.util")
			if lua_dev_utils.has_file(root_dir, lua_dev_utils.fqn("~/.dotfiles/nvim/.config/nvim")) then
				library.enabled = true
				library.runtime = true
				library.types = true
				library.plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" }
			end
		end,
	})
end

return M
