local M = {
	augroup_highlight = vim.api.nvim_create_augroup("Highlight", { clear = true }),
}

M.on_attach = function(client, bufnr)
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_clear_autocmds({ group = M.augroup_highlight, buffer = bufnr })

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
