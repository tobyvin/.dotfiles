local M = {}

M.on_attach = function(client, bufnr)
	if client.server_capabilities.documentHighlightProvider then
		M.augroup_highlight = vim.api.nvim_create_augroup("ReferenceHighlight", { clear = true })

		vim.api.nvim_create_autocmd("CursorHold", {
			group = M.augroup_highlight,
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
			desc = "Highlight lsp references",
		})

		vim.api.nvim_create_autocmd("CursorMoved", {
			group = M.augroup_highlight,
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
			desc = "Clear highlighted references",
		})
	end
end

return M
