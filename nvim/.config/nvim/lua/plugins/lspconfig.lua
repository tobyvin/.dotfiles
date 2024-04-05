---@type LazyPluginSpec
local M = {
	"neovim/nvim-lspconfig",
	event = "BufReadPre",
	dependencies = {
		-- { "hrsh7th/cmp-nvim-lsp", opts = {} },
		"nvimdev/epo.nvim",
		{ "folke/neodev.nvim", opts = {} },
		{ "folke/neoconf.nvim", cmd = "Neoconf", dependencies = { "nvim-lspconfig" }, opts = {} },
	},
}

function M:config()
	require("neoconf")
	-- require("lspconfig").util.default_config.capabilities =
	-- 	require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

	require("lspconfig").util.default_config.capabilities =
		vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), require("epo").register_cap())

	require("lspconfig.ui.windows").default_options.border = "single"

	local avail = require("lspconfig").util.available_servers()

	vim.iter(require("tobyvin.lsp.configs")):each(function(name, config)
		if not vim.tbl_contains(avail, name) then
			require("lspconfig")[name].setup(config)
		end

		require("tobyvin.lsp.configs")[name] = require("lspconfig")[name].manager.config
	end)
end

return M
