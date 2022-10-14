local lsp = require("tobyvin.lsp")
local M = {}

M.setup = function()
	local status_ok, lspconfig = pcall(require, "lspconfig")
	if not status_ok then
		vim.notify("Failed to load module 'lspconfig'", vim.log.levels.ERROR)
		return
	end

	lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, lsp.default_config)

	for name, config in pairs(lsp.configs) do
		if name ~= "rust-analyzer" then
			lspconfig[name].setup(config)
		end
	end

	require("lsp_signature").setup({
		bind = true,
		handler_opts = {
			border = "rounded",
		},
	})
end

return M
