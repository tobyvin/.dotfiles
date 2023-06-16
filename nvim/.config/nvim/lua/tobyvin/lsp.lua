local augroup = vim.api.nvim_create_augroup("lsp", { clear = true })

for method, handler in pairs(require("tobyvin.lsp.handlers")) do
	vim.lsp.handlers[method] = handler
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	desc = "setup lsp",
	callback = function(args)
		---@type lsp.Client
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if client.server_capabilities.documentHighlightProvider then
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				group = augroup,
				buffer = args.buf,
				callback = vim.lsp.buf.document_highlight,
				desc = "highlight references",
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				group = augroup,
				buffer = args.buf,
				callback = vim.lsp.buf.clear_references,
				desc = "clear references",
			})
		end

		if client.server_capabilities.documentFormattingProvider then
			vim.keymap.set("n", "gqq", vim.lsp.buf.format, { desc = "format", buffer = args.buf })
			vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "format", buffer = args.buf })
		end

		if client.server_capabilities.documentRangeFormattingProvider then
			vim.keymap.set("v", "<leader>lf", vim.lsp.buf.format, { desc = "format", buffer = args.buf })
		end

		if client.server_capabilities.hoverProvider then
			vim.keymap.set({ "n", "v" }, "K", vim.lsp.buf.hover, { desc = "hover", buffer = args.buf })
		end

		if client.server_capabilities.signatureHelpProvider then
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, {
				desc = "signature help",
				buffer = args.buf,
			})
		end

		local on_list = function(options)
			vim.fn.setqflist({}, " ", options)
			vim.api.nvim_command("cfirst")
		end

		if client.server_capabilities.declarationProvider then
			vim.keymap.set("n", "gD", function()
				vim.lsp.buf.declaration({ on_list = on_list })
			end, { desc = "declaration", buffer = args.buf })
		end

		if client.server_capabilities.definitionProvider then
			vim.keymap.set("n", "gd", function()
				vim.lsp.buf.definition({ on_list = on_list })
			end, { desc = "definition", buffer = args.buf })
		end

		if client.server_capabilities.typeDefinitionProvider then
			vim.keymap.set("n", "go", function()
				vim.lsp.buf.type_definition({ on_list = on_list })
			end, { desc = "type definition", buffer = args.buf })
		end

		if client.server_capabilities.implementationProvider then
			vim.keymap.set("n", "gi", function()
				vim.lsp.buf.implementation({ on_list = on_list })
			end, { desc = "implementation", buffer = args.buf })
		end

		if client.server_capabilities.referencesProvider then
			vim.keymap.set("n", "gr", function()
				vim.lsp.buf.references(nil, { on_list = on_list })
			end, { desc = "references", buffer = args.buf })
		end

		if client.server_capabilities.renameProvider then
			vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, {
				desc = "rename",
				buffer = args.buf,
			})
		end

		if client.server_capabilities.codeActionProvider then
			vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, {
				desc = "code action",
				buffer = args.buf,
			})
		end

		if client.server_capabilities.experimental then
			if client.server_capabilities.experimental.externalDocs then
				vim.keymap.set("n", "gx", vim.lsp.buf.external_docs, {
					desc = "external_docs",
					buffer = args.buf,
				})
			end
		end
	end,
})
