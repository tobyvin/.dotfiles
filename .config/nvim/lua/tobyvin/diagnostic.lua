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
