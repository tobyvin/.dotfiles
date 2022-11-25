local status_ok, mason = pcall(require, "mason")
if not status_ok then
	vim.notify("Failed to load module 'mason'", vim.log.levels.ERROR)
	return
end

local nil_wrap = function(func)
	return function(opts)
		func(vim.F.if_nil(opts, {}))
	end
end

mason.setup({
	ui = {
		border = "single",
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

local mason_update_all = require("mason-update-all")
local mason_lspconfig = require("mason-lspconfig.api.command")
local mason_null_ls = require("mason-null-ls.api.command")
local mason_nvim_dap = require("mason-nvim-dap.api.command")

local api = require("mason.api.command")
api.UpdateAll = mason_update_all.update_all
api.LspInstall = nil_wrap(mason_lspconfig.LspInstall)
api.LspUninstall = nil_wrap(mason_lspconfig.LspUninstall)
api.NullLsInstall = nil_wrap(mason_null_ls.NullLsInstall)
api.NullLsUninstall = nil_wrap(mason_null_ls.NullLsUninstall)
api.DapInstall = nil_wrap(mason_nvim_dap.DapInstall)
api.DapUninstall = nil_wrap(mason_nvim_dap.DapUninstall)

vim.keymap.set("n", "<leader>ii", api.Mason, { desc = "mason" })
vim.keymap.set("n", "<leader>iI", api.MasonLog, { desc = "log" })
vim.keymap.set("n", "<leader>iu", api.UpdateAll, { desc = "update all" })
vim.keymap.set("n", "<leader>il", api.LspInstall, { desc = "lsp install" })
vim.keymap.set("n", "<leader>iL", api.LspUninstall, { desc = "lsp uninstall" })
vim.keymap.set("n", "<leader>in", api.NullLsInstall, { desc = "null-ls install" })
vim.keymap.set("n", "<leader>iN", api.NullLsUninstall, { desc = "null-ls uninstall" })
vim.keymap.set("n", "<leader>id", api.DapInstall, { desc = "dap install" })
vim.keymap.set("n", "<leader>iD", api.DapUninstall, { desc = "dap uninstall" })
