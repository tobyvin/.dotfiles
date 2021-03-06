local M = {}

M.setup = function()
	local status_ok, cmp_npm = pcall(require, "cmp-npm")
	if not status_ok then
		vim.notify("Failed to load module 'cmp-npm'", "error")
		return
	end

	cmp_npm.setup()
end

return M
