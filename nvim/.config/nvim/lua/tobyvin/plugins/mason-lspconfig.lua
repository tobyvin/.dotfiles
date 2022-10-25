local M = {}

M.install = function()
	require("mason-lspconfig.api.command").LspInstall({})
end

M.setup = function()
	local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
	if not status_ok then
		vim.notify("Failed to load module 'mason-lspconfig'", vim.log.levels.ERROR)
		return
	end

	mason_lspconfig.setup()

	vim.api.nvim_create_autocmd("User", {
		pattern = "LspAttach",
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client.name ~= "null-ls" then
				vim.keymap.set("n", "<leader>li", M.install, { desc = "LSP Install", buffer = args.buf })
			end
		end,
	})
end

return M
