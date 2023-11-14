local on_list = function(options)
	vim.fn.setqflist({}, " ", options)
	vim.api.nvim_command("cfirst")
end

local M = {
	["textDocument/documentHighlight"] = function(bufnr)
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
			desc = "lsp document highlight",
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
			desc = "lsp clear references",
		})
	end,
	["textDocument/signatureHelp"] = function(bufnr)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, {
			buffer = bufnr,
			desc = "signature help",
		})
	end,
	["textDocument/declaration"] = function(bufnr)
		vim.keymap.set("n", "gD", function()
			vim.lsp.buf.declaration({ on_list = on_list })
		end, { buffer = bufnr, desc = "declaration" })
	end,
	["textDocument/definition"] = function(bufnr)
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition({ on_list = on_list })
		end, { buffer = bufnr, desc = "definition" })
	end,
	["textDocument/typeDefinition"] = function(bufnr)
		vim.keymap.set("n", "go", function()
			vim.lsp.buf.type_definition({ on_list = on_list })
		end, { buffer = bufnr, desc = "type definition" })
	end,
	["textDocument/implementation"] = function(bufnr)
		vim.keymap.set("n", "gi", function()
			vim.lsp.buf.implementation({ on_list = on_list })
		end, { buffer = bufnr, desc = "implementation" })
	end,
	["textDocument/inlayHint"] = function(bufnr)
		vim.lsp.inlay_hint.enable(bufnr, true)
	end,
	["textDocument/references"] = function(bufnr)
		vim.keymap.set("n", "gr", function()
			vim.lsp.buf.references(nil, { on_list = on_list })
		end, { buffer = bufnr, desc = "references" })
	end,
	["textDocument/rename"] = function(bufnr)
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, {
			buffer = bufnr,
			desc = "rename",
		})
	end,
	["textDocument/codeAction"] = function(bufnr)
		vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, {
			buffer = bufnr,
			desc = "code action",
		})
	end,
	["experimental/externalDocs"] = function(bufnr)
		vim.keymap.set("n", "gx", vim.lsp.buf.external_docs, {
			buffer = bufnr,
			desc = "external_docs",
		})
	end,
}

return M
