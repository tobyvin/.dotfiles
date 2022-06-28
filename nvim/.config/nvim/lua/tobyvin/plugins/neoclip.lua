local M = {}

M.setup = function()
	local status_ok, neoclip = pcall(require, "neoclip")
	if not status_ok then
		vim.notify("Failed to load module 'neoclip'", "error")
		return
	end

	neoclip.setup({
		continuous_sync = false,
		enable_persistent_history = false,
	})

end

return M
