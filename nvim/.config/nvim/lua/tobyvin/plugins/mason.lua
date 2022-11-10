local M = {}

M.install = function()
	require("mason.api.command").Mason({})
end

M.setup = function()
	local status_ok, mason = pcall(require, "mason")
	if not status_ok then
		vim.notify("Failed to load module 'mason'", vim.log.levels.ERROR)
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

	vim.keymap.set("n", "<leader>m", M.install, { desc = "mason" })
end

return M
