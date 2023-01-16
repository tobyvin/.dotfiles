local augroup = vim.api.nvim_create_augroup("lsp", {})

for method, handler in pairs(require("tobyvin.lsp.handlers")) do
	vim.lsp.handlers[method] = handler
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	desc = "setup lsp",
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if client.server_capabilities.definitionProvider then
			vim.bo[args.buf].tagfunc = "v:lua.vim.lsp.tagfunc"
		end

		if client.server_capabilities.documentFormattingProvider then
			vim.api.nvim_buf_set_option(args.buf, "formatexpr", "v:lua.vim.lsp.formatexpr()")
		end

		if client.server_capabilities.documentHighlightProvider then
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				group = augroup,
				buffer = args.buf,
				callback = vim.lsp.buf.document_highlight,
				desc = "document highlight",
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				group = augroup,
				buffer = args.buf,
				callback = vim.lsp.buf.clear_references,
				desc = "clear references",
			})
		end

		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "signature help", buffer = args.buf })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "definition", buffer = args.buf })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "declaration", buffer = args.buf })
		vim.keymap.set("n", "go", vim.lsp.buf.type_definition, { desc = "type definition", buffer = args.buf })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "implementation", buffer = args.buf })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "references", buffer = args.buf })

		vim.keymap.set({ "n", "v" }, "<leader>lf", vim.lsp.buf.format, { desc = "format", buffer = args.buf })
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "rename", buffer = args.buf })
		vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "code action", buffer = args.buf })
		vim.keymap.set("n", "<leader>ll", vim.lsp.codelens.run, { desc = "codelens", buffer = args.buf })

		local register_opts = { desc = "lsp", buffer = args.buf, priority = 1 }
		require("tobyvin.utils.hover").register(vim.lsp.buf.hover, register_opts)
		require("tobyvin.utils.documentation").register(vim.lsp.buf.external_docs, register_opts)
	end,
})
