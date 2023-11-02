---@type LazyPluginSpec
local M = {
	"neovim/nvim-lspconfig",
	event = "BufReadPre",
	dependencies = {
		{ "hrsh7th/cmp-nvim-lsp", opts = {} },
		{ "folke/neodev.nvim", opts = {} },
		{ "folke/neoconf.nvim", cmd = "Neoconf", dependencies = { "nvim-lspconfig" }, opts = {} },
	},
}

function M:config()
	require("neoconf")
	require("lspconfig.util").default_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
	require("lspconfig.ui.windows").default_options.border = "single"

	local available = require("lspconfig.util").available_servers()
	for name, config in pairs(require("tobyvin.lsp.configs")) do
		if not vim.tbl_contains(available, name) then
			require("lspconfig")[name].setup(config)
		end
	end
end

return M
