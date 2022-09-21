local M = {}

M.setup = function()
	local status_ok, mason = pcall(require, "mason")
	if not status_ok then
		vim.notify("Failed to load module 'mason'", "error")
		return
	end

	mason.setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})

	vim.keymap.set("n", "<leader>i", ":Mason<CR>", { desc = "Mason" })
	vim.keymap.set("n", "<leader>I", ":MasonLog<CR>", { desc = "Mason Log" })
end

return M