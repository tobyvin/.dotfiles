local M = {}

M.on_attach = function(client, bufnr)
	if client.server_capabilities.documentHighlightProvider then
		local augroup_highlight = vim.api.nvim_create_augroup("DocumentHighlight", { clear = false })

		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = augroup_highlight,
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
			desc = "Highlight lsp references",
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			group = augroup_highlight,
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
			desc = "Clear highlighted references",
		})
	end
end

return M
