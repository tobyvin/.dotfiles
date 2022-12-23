local M = {}

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("tobyvin_lsp", { clear = true }),
	desc = "lsp",
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		vim.api.nvim_exec_autocmds("User", { pattern = "LspAttach", data = { client_id = client.id } })
	end,
})

require("tobyvin.lsp.handlers")
require("tobyvin.lsp.highlighting")
require("tobyvin.lsp.formatting")

setmetatable(M, {
	__index = function(t, k)
		local ok, val = pcall(require, string.format("tobyvin.lsp.%s", k))

		if ok then
			rawset(t, k, val)
		end

		return val
	end,
})

return M
