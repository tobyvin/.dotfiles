local M = {}

M.setup = function()
	local status_ok, zk = pcall(require, "zk")
	if not status_ok then
		vim.notify("Failed to load module 'zk'", vim.log.levels.ERROR)
		return
	end

	-- vim.keymap.set("n", "<leader>u", zk.toggle, { desc = "Toggle zk" })
	zk.setup()
end

return M
