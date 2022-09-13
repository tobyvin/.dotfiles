local utils = require("tobyvin.utils")
local M = {}

M.on_attach = function(_, bufnr)
	vim.api.nvim_create_autocmd("CursorHold", {
		buffer = bufnr,
		callback = function()
			local opts = {
				focusable = false,
				close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
				border = "rounded",
				source = "always",
				prefix = " ",
				scope = "cursor",
			}
			vim.diagnostic.open_float(nil, opts)
		end,
	})

	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show Diagnostic", buffer = bufnr })
	vim.keymap.set("n", "<leader>E", vim.diagnostic.setloclist, { desc = "List Diagnostic", buffer = bufnr })
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic", buffer = bufnr })
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic", buffer = bufnr })
end

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

	vim.fn.sign_define("DiagnosticSignError", utils.diagnostic_signs.error)
	vim.fn.sign_define("DiagnosticSignWarn", utils.diagnostic_signs.warn)
	vim.fn.sign_define("DiagnosticSignInfo", utils.diagnostic_signs.info)
	vim.fn.sign_define("DiagnosticSignHint", utils.diagnostic_signs.hint)
end

return M
