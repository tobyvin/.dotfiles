function vim.lsp.buf.external_docs()
	local params = vim.lsp.util.make_position_params()
	return vim.lsp.buf_request(0, "experimental/externalDocs", params)
end

return {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "single",
	}),

	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "single",
	}),
}
