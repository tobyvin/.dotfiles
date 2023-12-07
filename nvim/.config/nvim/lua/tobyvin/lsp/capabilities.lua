local ms = vim.lsp.protocol.Methods

local M = {
	[ms.textDocument_documentHighlight] = function(bufnr)
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
			desc = "document highlight",
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
			desc = "clear references",
		})
	end,
	[ms.textDocument_signatureHelp] = function(bufnr)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, {
			buffer = bufnr,
			desc = "signature help",
		})
	end,
	[ms.textDocument_documentSymbol] = function(bufnr)
		vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, {
			buffer = bufnr,
			desc = "definition",
		})
	end,
	[ms.textDocument_declaration] = function(bufnr)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
			buffer = bufnr,
			desc = "declaration",
		})
	end,
	[ms.textDocument_definition] = function(bufnr)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
			buffer = bufnr,
			desc = "definition",
		})
	end,
	[ms.textDocument_typeDefinition] = function(bufnr)
		vim.keymap.set("n", "go", vim.lsp.buf.type_definition, {
			buffer = bufnr,
			desc = "type definition",
		})
	end,
	[ms.textDocument_implementation] = function(bufnr)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {
			buffer = bufnr,
			desc = "implementation",
		})
	end,
	[ms.textDocument_inlayHint] = vim.lsp.inlay_hint.enable,
	[ms.textDocument_references] = function(bufnr)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, {
			buffer = bufnr,
			desc = "references",
		})
	end,
	[ms.textDocument_rename] = function(bufnr)
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, {
			buffer = bufnr,
			desc = "rename",
		})
	end,
	[ms.textDocument_codeAction] = function(bufnr)
		vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, {
			buffer = bufnr,
			desc = "code action",
		})
	end,
}

return M