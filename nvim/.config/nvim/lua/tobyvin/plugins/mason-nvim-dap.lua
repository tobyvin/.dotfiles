local M = {}

M.install = function()
	require("mason-nvim-dap.api.command").DapInstall({})
end

M.setup = function()
	local status_ok, mason_nvim_dap = pcall(require, "mason-nvim-dap")
	if not status_ok then
		vim.notify("Failed to load module 'mason-nvim-dap'", vim.log.levels.ERROR)
		return
	end

	mason_nvim_dap.setup()

	vim.keymap.set("n", "<leader>dI", M.install, { desc = "dap install" })
end

return M
