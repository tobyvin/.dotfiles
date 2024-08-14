---@type LazySpec
local M = {
	"neovim/nvim-lspconfig",
	version = false,
	event = "BufReadPre",
	dependencies = { "hrsh7th/cmp-nvim-lsp" },
}

function M:config()
	-- local capabilities = require("lspconfig").util.default_config.capabilities
	-- capabilities = vim.tbl_deep_extend(
	-- 	"force",
	-- 	capabilities,
	-- 	require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
	-- )
	-- require("lspconfig").util.default_config.capabilities = capabilities

	require("lspconfig.ui.windows").default_options.border = "single"

	local available_servers = require("lspconfig").util.available_servers()

	vim.iter(require("tobyvin.lsp.configs")):each(function(name, config)
		if not vim.tbl_contains(available_servers, name) then
			require("lspconfig")[name].setup(config)
		end
	end)
end

return M
