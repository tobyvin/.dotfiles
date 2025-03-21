local augroup = vim.api.nvim_create_augroup("user.lsp", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	desc = "setup lsp handlers",
	callback = function()
		for method, handler in pairs(require("lsp.handlers")) do
			if type(handler) == "table" then
				handler = vim.lsp.with(vim.lsp.handlers[method], handler) --[[@as table]]
			end
			vim.lsp.handlers[method] = handler --[[@as function]]
		end
		return true
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	desc = "setup lsp capabilities",
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		local config = require("lsp.configs")[client.name]
		if config then
			vim.iter(config.server_capabilities or {}):each(function(name, value)
				client.server_capabilities[name] = value
			end)
		end

		for method, setup_handler in pairs(require("lsp.capabilities")) do
			if client.supports_method(method, { bufnr = args.buf }) then
				setup_handler(args.buf, client)
			end
		end
	end,
})

vim.lsp.config("*", {
	root_markers = { ".git" },
})
