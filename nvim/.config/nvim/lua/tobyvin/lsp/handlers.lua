local M = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "single",
	}),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "single",
	}),
	["experimental/externalDocs"] = function(_, url)
		if url then
			if vim.fn.executable("xdg-open") == 1 then
				require("plenary.job"):new({ command = "xdg-open", args = { url } }):start()
			else
				pcall(vim.fn["netrw#BrowseX"], url, 0)
			end
		end
	end,
}

function vim.lsp.buf.external_docs()
	local params = vim.lsp.util.make_position_params()
	return vim.lsp.buf_request(0, "experimental/externalDocs", params, M["experimental/externalDocs"])
end

return M
