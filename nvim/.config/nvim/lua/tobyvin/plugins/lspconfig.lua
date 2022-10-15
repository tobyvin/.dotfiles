local lsp = require("tobyvin.lsp")
local M = {}

M.is_setup = function(name)
	local available_servers = require("lspconfig").util.available_servers()
	return name == "default" or vim.tbl_contains(available_servers, name)
end

M.setup = function()
	local status_ok, lspconfig = pcall(require, "lspconfig")
	if not status_ok then
		vim.notify("Failed to load module 'lspconfig'", vim.log.levels.ERROR)
		return
	end

	lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, lsp.configs.default)

	for name, config in pairs(lsp.configs) do
		if not M.is_setup(name) then
			lspconfig[name].setup(config)
		end
	end
end

return M
