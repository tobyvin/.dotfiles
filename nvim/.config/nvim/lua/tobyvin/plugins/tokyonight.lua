local M = {}

M.setup = function()
	local status_ok, tokyonight = pcall(require, "tokyonight")
	if not status_ok then
		vim.notify("Failed to load module 'tokyonight'", vim.log.levels.ERROR)
		return
	end

	tokyonight.setup({
		styles = {
			sidebars = "transparent",
			floats = "transparent",
		},
		transparent = true,
	})
end

return M
