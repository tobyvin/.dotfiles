local M = {}

M.setup = function()
	vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("tobyvin_lsp_highlighting", { clear = true }),
		desc = "setup lsp highlighting",
		callback = function(args)
			local bufnr = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)

			if client.server_capabilities.documentHighlightProvider then
				local augroup_highlight = vim.api.nvim_create_augroup("DocumentHighlight", { clear = false })

				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					group = augroup_highlight,
					buffer = bufnr,
					callback = vim.lsp.buf.document_highlight,
					desc = "Highlight lsp references",
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					group = augroup_highlight,
					buffer = bufnr,
					callback = vim.lsp.buf.clear_references,
					desc = "Clear highlighted references",
				})
			end
		end,
	})
end

return M
