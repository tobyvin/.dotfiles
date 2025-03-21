---@type LazySpec
local M = {
	"neovim/nvim-lspconfig",
	version = false,
	event = "BufReadPre",
}

function M:config()
	require("lspconfig.ui.windows").default_options.border = "single"

	local available_servers = require("lspconfig").util.available_servers()

	vim.iter(require("lsp.configs")):each(function(name, config)
		if not vim.tbl_contains(available_servers, name) then
			require("lspconfig")[name].setup(config)
		end
	end)
end

return M
