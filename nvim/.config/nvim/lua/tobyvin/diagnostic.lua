local utils = require("tobyvin.utils.diagnostic")

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

vim.fn.sign_define("DiagnosticSignError", utils.signs.error)
vim.fn.sign_define("DiagnosticSignWarn", utils.signs.warn)
vim.fn.sign_define("DiagnosticSignInfo", utils.signs.info)
vim.fn.sign_define("DiagnosticSignHint", utils.signs.hint)

vim.keymap.set("n", "]d", utils.goto_next, { desc = "next diagnostic" })
vim.keymap.set("n", "[d", utils.goto_prev, { desc = "prev diagnostic" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "open diagnostic float" })
vim.keymap.set("n", "gL", vim.diagnostic.setqflist, { desc = "qf diagnostic" })

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float({
			focus = false,
			close_events = { "InsertEnter", "CursorMoved" },
		})
	end,
})
