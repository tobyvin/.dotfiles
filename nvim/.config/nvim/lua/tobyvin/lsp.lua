local utils = require("tobyvin.utils")
local lsp = {
	configs = require("tobyvin.lsp.configs"),
	handlers = require("tobyvin.lsp.handlers"),
	highlighting = require("tobyvin.lsp.highlighting"),
	formatting = require("tobyvin.lsp.formatting"),
}

lsp.setup = function()
	lsp.handlers.setup()
	lsp.highlighting.setup()
	lsp.formatting.setup()

	vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("tobyvin_lsp", { clear = true }),
		desc = "lsp",
		callback = function(args)
			local bufnr = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)

			utils.keymap.group("n", "<leader>l", { desc = "LSP", buffer = bufnr })
			vim.keymap.set("n", "<leader>L", "<CMD>LspInfo<CR>", { desc = "LSP info" })
			vim.keymap.set("n", "<leader>k", utils.documentation.open, { desc = "Documentation", buffer = bufnr })
			vim.api.nvim_exec_autocmds("User", { pattern = "LspAttach", data = { client_id = client.id } })
		end,
	})
end

return lsp
