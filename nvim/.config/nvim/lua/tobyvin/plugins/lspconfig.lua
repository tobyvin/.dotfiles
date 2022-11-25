local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
	vim.notify("Failed to load module 'lspconfig'", vim.log.levels.ERROR)
	return
end

local lsp = require("tobyvin.lsp")

require("lspconfig.ui.windows").default_options.border = "single"

lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, lsp.default_config)

local available = lspconfig.util.available_servers()
for name, config in pairs(lsp.configs) do
	if not vim.tbl_contains(available, name) then
		lspconfig[name].setup(config)
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("tobyvin_lsp_config", { clear = true }),
	desc = "lsp",
	callback = function(args)
		local lspinfo = require("lspconfig.ui.lspinfo")
		vim.keymap.set("n", "<leader>li", lspinfo, { desc = "lsp info", buffer = args.buf })
	end,
})
