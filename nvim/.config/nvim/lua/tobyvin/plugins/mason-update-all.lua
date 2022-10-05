local M = {}

M.setup = function()
	local status_ok, mason_update_all = pcall(require, "mason-update-all")
	if not status_ok then
		vim.notify("Failed to load module 'mason-update-all'", vim.log.levels.ERROR)
		return
	end

	mason_update_all.setup()

	vim.keymap.set("n", "<leader>M", mason_update_all.update_all, { desc = "Update All" })
end

return M
