local utils = require("tobyvin.utils")

vim.diagnostic.config({
	virtual_text = {
		source = "if_many",
	},
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = true,
	float = {
		border = "single",
		scope = "cursor",
	},
})

vim.fn.sign_define("DiagnosticSignError", utils.diagnostic.signs.error)
vim.fn.sign_define("DiagnosticSignWarn", utils.diagnostic.signs.warn)
vim.fn.sign_define("DiagnosticSignInfo", utils.diagnostic.signs.info)
vim.fn.sign_define("DiagnosticSignHint", utils.diagnostic.signs.hint)

vim.keymap.set("n", "]d", utils.diagnostic.goto_next, { desc = "next diagnostic" })
vim.keymap.set("n", "[d", utils.diagnostic.goto_prev, { desc = "prev diagnostic" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "open diagnostic float" })
vim.keymap.set("n", "gL", vim.diagnostic.setqflist, { desc = "qf diagnostic" })

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float()
	end,
})
