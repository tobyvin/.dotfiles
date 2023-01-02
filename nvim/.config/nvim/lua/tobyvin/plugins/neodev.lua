local M = {
	"folke/neodev.nvim",
	config = {
		experimental = {
			-- much faster, but needs a nightly built of lua-language-server
			pathStrict = true,
		},
		override = function(root_dir, library)
			local lua_dev_utils = require("lua-dev.util")
			if lua_dev_utils.has_file(root_dir, lua_dev_utils.fqn("~/.dotfiles/nvim/.config/nvim")) then
				library.plugins = true
			end
		end,
		lspconfig = false,
	},
}

function M.init()
	require("tobyvin.lsp.configs").sumneko_lua.before_init = function()
		require("neodev.lsp").before_init()
	end
end

return M
