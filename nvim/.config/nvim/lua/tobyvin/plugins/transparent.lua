local M = {}

M.highlights = function()
	require("transparent").setup({
		enable = true,
		extra_groups = {
			"Normal",
			"NormalNC",
			"StatusLine",
			"StatusLineNC",
			"WhichKeyFloat",
			"CursorLine",
			"ColorColumn",
		},
	})
end

M.setup = function()
	local status_ok, _ = pcall(require, "transparent")
	if not status_ok then
		vim.notify("failed to load module 'transparent'", vim.log.levels.ERROR)
		return
	end

	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = M.highlights,
	})
end

return M
