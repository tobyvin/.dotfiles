local M = {}

M.setup = function()
	local status_ok, surround = pcall(require, "surround")
	if not status_ok then
		vim.notify("Failed to load module 'surround'", "error")
		return
	end

	surround.setup({
		map_insert_mode = false,
	})
end

return M
