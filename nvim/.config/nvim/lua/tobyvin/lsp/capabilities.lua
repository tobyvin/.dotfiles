local ms = vim.lsp.protocol.Methods

---@type table<string, fun(bufnr:number, client:vim.lsp.Client)>
local M = {
	[ms.dollar_progress] = function(_, client)
		-- See: https://github.com/neovim/neovim/pull/26098
		client.progress = vim.ringbuf(2048) --[[@as vim.lsp.Client.Progress]]
		client.progress.pending = {}
	end,
	[ms.textDocument_documentHighlight] = function(bufnr)
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
			desc = "vim.lsp.buf.document_highlight()",
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
			desc = "vim.lsp.buf.clear_references()",
		})
	end,
	[ms.textDocument_documentSymbol] = function(bufnr)
		vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, {
			buffer = bufnr,
			desc = "definition",
		})
	end,
	[ms.textDocument_typeDefinition] = function(bufnr)
		vim.keymap.set("n", "go", vim.lsp.buf.type_definition, {
			buffer = bufnr,
			desc = "vim.lsp.buf.type_definition()",
		})
	end,
	[ms.textDocument_implementation] = function(bufnr)
		vim.keymap.set("n", "g<c-i>", vim.lsp.buf.implementation, {
			buffer = bufnr,
			desc = "vim.lsp.buf.implementation()",
		})
	end,
	[ms.textDocument_inlayHint] = function(bufnr)
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end,

	-- in preparation for https://github.com/neovim/neovim/pull/28500
	[ms.textDocument_signatureHelp] = function(bufnr)
		vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, {
			buffer = bufnr,
			desc = "vim.lsp.buf.signature_help()",
		})
	end,
	[ms.textDocument_references] = function(bufnr)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, {
			buffer = bufnr,
			desc = "vim.lsp.buf.references()",
		})
	end,
	[ms.textDocument_rename] = function(bufnr)
		vim.keymap.set("n", "crn", vim.lsp.buf.rename, {
			buffer = bufnr,
			desc = "vim.lsp.buf.rename()",
		})
	end,
	[ms.textDocument_codeAction] = function(bufnr)
		vim.keymap.set({ "n", "v" }, "crr", vim.lsp.buf.code_action, {
			buffer = bufnr,
			desc = "vim.lsp.buf.code_action()",
		})
	end,
}

return M
