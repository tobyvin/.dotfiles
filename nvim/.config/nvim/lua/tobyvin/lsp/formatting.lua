vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("tobyvin_lsp_formatting", { clear = true }),
	desc = "setup lsp formatting",
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client.name == "sumneko_lua" then
			return
		end

		if client.server_capabilities.documentFormattingProvider then
			vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
			vim.api.nvim_buf_create_user_command(bufnr, "Format", vim.lsp.buf.format, { nargs = "*" })
			vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "format", buffer = bufnr })
		end

		if client.server_capabilities.documentRangeFormattingProvider then
			vim.api.nvim_buf_create_user_command(bufnr, "FormatRange", vim.lsp.buf.format, { nargs = "*" })
			vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "format range", buffer = bufnr })
		end
	end,
})
