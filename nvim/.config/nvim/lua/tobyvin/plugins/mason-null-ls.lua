local M = {}

M.install = function()
	require("mason-null-ls.api.command").NullLsInstall({})
end

M.setup = function()
	local status_ok, mason_null_ls = pcall(require, "mason-null-ls")
	if not status_ok then
		vim.notify("Failed to load module 'mason-null-ls'", vim.log.levels.ERROR)
		return
	end

	mason_null_ls.setup()

	vim.api.nvim_create_autocmd("User", {
		pattern = "LspAttach",
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client.name == "null-ls" then
				vim.keymap.set("n", "<leader>lN", M.install, { desc = "null-ls install", buffer = args.buf })
			end
		end,
	})
end

return M
