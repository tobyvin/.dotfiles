local M = {}

M.highlights = function()
	-- vim.api.nvim_set_hl(0, "LeapMatch", { link = "IncSearch" })
	-- vim.api.nvim_set_hl(0, "LeapLabelSelected", { link = "IncSearch" })
	vim.api.nvim_set_hl(0, "LeapLabelPrimary", { link = "IncSearch" })
	-- vim.api.nvim_set_hl(0, "LeapLabelSecondary", { link = "IncSearch" })
end

M.setup = function()
	local status_ok, leap = pcall(require, "leap")
	if not status_ok then
		vim.notify("Failed to load module 'leap'", vim.log.levels.ERROR)
		return
	end

	leap.set_default_keymaps()

	M.highlights()

	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = M.highlights,
	})
end

return M
