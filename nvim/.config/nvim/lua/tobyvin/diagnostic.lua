local diagnostic = require("tobyvin.utils.diagnostic")

vim.diagnostic.config({
	virtual_text = {
		source = "if_many",
	},
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = true,
	float = {
		source = "always",
		border = "single",
		scope = "cursor",
	},
})

vim.fn.sign_define("DiagnosticSignError", diagnostic.signs.error)
vim.fn.sign_define("DiagnosticSignWarn", diagnostic.signs.warn)
vim.fn.sign_define("DiagnosticSignInfo", diagnostic.signs.info)
vim.fn.sign_define("DiagnosticSignHint", diagnostic.signs.hint)

vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "open diagnostic float" })
vim.keymap.set("n", "gL", vim.diagnostic.setqflist, { desc = "qf diagnostic" })
vim.keymap.set("n", "]g", vim.diagnostic.goto_next, { desc = "next diagnostic" })
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, { desc = "prev diagnostic" })
vim.keymap.set("n", "]G", diagnostic.goto_next_workspace, { desc = "next workspace diagnostic" })
vim.keymap.set("n", "[G", diagnostic.goto_prev_workspace, { desc = "prev workspace diagnostic" })
