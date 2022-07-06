local M = {}

M.setup = function()
	local status_ok, presence = pcall(require, "presence")
	if not status_ok then
		vim.notify("Failed to load module 'presence'", "error")
		return
	end

	presence:setup()
end

return M
