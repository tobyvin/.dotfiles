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

	require("lspconfig.ui.windows").default_options.border = "single"

	lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, lsp.configs.default)

	for name, config in pairs(lsp.configs) do
		if not M.is_setup(name) then
			lspconfig[name].setup(config)
		end
	end

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("tobyvin_lsp", { clear = true }),
		desc = "lsp",
		callback = function(args)
			local lspinfo = require("lspconfig.ui.lspinfo")
			vim.keymap.set("n", "<leader>li", lspinfo, { desc = "LSP info", buffer = args.buf })
		end,
	})
end

return M
