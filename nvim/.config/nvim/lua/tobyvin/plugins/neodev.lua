local M = {
	"folke/neodev.nvim",
}

function M.config()
	require("neodev").setup({
		experimental = {
			pathStrict = true,
		},
		override = function(root_dir, library)
			local lua_dev_utils = require("lua-dev.util")
			if lua_dev_utils.has_file(root_dir, lua_dev_utils.fqn("~/.dotfiles/nvim/.config/nvim")) then
				library.enabled = true
			end
		end,
	})
end

return M
