local augroup = vim.api.nvim_create_augroup("lsp", { clear = true })

for method, handler in pairs(require("tobyvin.lsp.handlers")) do
	vim.lsp.handlers[method] = handler
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	desc = "setup lsp",
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		for method, setup_handler in pairs(require("tobyvin.lsp.capabilities")) do
			if client.supports_method(method, { bufnr = args.buf }) then
				setup_handler(args.buf)
			end
		end
	end,
})
