local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	vim.diagnostic.config({
		virtual_text = {
			source = "if_many",
		},
		signs = true,
		underline = true,
		update_in_insert = true,
		severity_sort = true,
	})

	vim.fn.sign_define("DiagnosticSignError", utils.diagnostic.signs.error)
	vim.fn.sign_define("DiagnosticSignWarn", utils.diagnostic.signs.warn)
	vim.fn.sign_define("DiagnosticSignInfo", utils.diagnostic.signs.info)
	vim.fn.sign_define("DiagnosticSignHint", utils.diagnostic.signs.hint)

	vim.api.nvim_create_autocmd("CursorHold", {
		callback = function()
			local opts = {
				focusable = false,
				close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
				border = "single",
				source = "always",
				prefix = " ",
				scope = "cursor",
			}
			vim.diagnostic.open_float(nil, opts)
		end,
	})

	vim.keymap.set("n", "<leader>e", vim.diagnostic.setloclist, { desc = "Buffer Diagnostic" })
	vim.keymap.set("n", "<leader>E", vim.diagnostic.setqflist, { desc = "Workspace Diagnostic" })
	vim.keymap.set("n", "]d", utils.diagnostic.goto_next, { desc = "Next Diagnostic" })
	vim.keymap.set("n", "[d", utils.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
end

return M
