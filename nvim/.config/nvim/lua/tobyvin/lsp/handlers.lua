local ms = vim.lsp.protocol.Methods

local M = {
	[ms.textDocument_hover] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "single",
	}),
	[ms.textDocument_signatureHelp] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "single",
	}),
	["experimental/externalDocs"] = function(_, url)
		if url then
			vim.ui.open(url)
		end
	end,
}

function vim.lsp.buf.external_docs()
	local params = vim.lsp.util.make_position_params()
	return vim.lsp.buf_request(0, "experimental/externalDocs", params, M["experimental/externalDocs"])
end

return M
