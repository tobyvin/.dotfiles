local M = {}

M.setup = function()
	local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
	if not status_ok then
		vim.notify("Failed to load module 'mason-lspconfig'", "error")
		return
	end

	mason_lspconfig.setup()

	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client.name == "null-ls" then
				return
			end
			local bufnr = args.buf
			vim.keymap.set("n", "<leader>lI", "<CMD>LspInstall<CR>", { desc = "LSP Install", buffer = bufnr })
		end,
	})
end

return M
