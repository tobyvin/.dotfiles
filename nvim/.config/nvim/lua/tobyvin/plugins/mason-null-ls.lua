local M = {}

M.setup = function()
	local status_ok, mason_null_ls = pcall(require, "mason-null-ls")
	if not status_ok then
		vim.notify("Failed to load module 'mason-null-ls'", "error")
		return
	end

	mason_null_ls.setup()

	vim.keymap.set("n", "<leader>N", "<CMD>NullLsInstall<CR>", { desc = "Null-LS Install" })
end

return M
