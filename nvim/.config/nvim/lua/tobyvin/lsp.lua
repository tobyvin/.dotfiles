local augroup = vim.api.nvim_create_augroup("lsp", {})

for method, handler in pairs(require("tobyvin.lsp.handlers")) do
	vim.lsp.handlers[method] = handler
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	desc = "setup lsp",
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)

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

		if vim.tbl_get(client.server_capabilities, "experimental", "externalDocs") then
			vim.keymap.set("n", "gx", vim.lsp.buf.external_docs, { desc = "external_docs", buffer = args.buf })
		end

		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "hover", buffer = args.buf })
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
	end,
})
