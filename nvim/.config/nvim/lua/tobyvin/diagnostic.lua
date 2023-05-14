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

vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = " ", texthl = "DiagnosticSignHint" })

vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "open diagnostic float" })
vim.keymap.set("n", "gL", vim.diagnostic.setqflist, { desc = "qf diagnostic" })
vim.keymap.set("n", "]g", vim.diagnostic.goto_next, { desc = "next diagnostic" })
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, { desc = "prev diagnostic" })
