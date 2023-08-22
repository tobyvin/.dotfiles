---@type LazyPluginSpec
local M = {
	"williamboman/mason-lspconfig.nvim",
	version = "*",
	event = "BufReadPre",
	cmd = {
		"LspInstall",
		"LspUninstall",
	},
	dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
	opts = {
		handlers = {
			function(name)
				local config = require("tobyvin.lsp.configs")[name] or {}
				local available = require("lspconfig").util.available_servers()

				if not vim.tbl_contains(available, name) then
					require("lspconfig")[name].setup(config)
				end
			end,
		},
	},
}

return M
