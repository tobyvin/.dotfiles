local M = {}

M.on_attach = function(client, bufnr)
	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
		vim.api.nvim_buf_create_user_command(bufnr, "Format", vim.lsp.buf.format, { nargs = "*" })
		vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format", buffer = bufnr })
	end

	if client.server_capabilities.documentRangeFormattingProvider then
		vim.api.nvim_buf_create_user_command(bufnr, "FormatRange", vim.lsp.buf.format, { nargs = "*" })
		vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format Range", buffer = bufnr })
	end
end

return M
