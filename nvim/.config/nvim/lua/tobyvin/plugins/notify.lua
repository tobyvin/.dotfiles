local M = {}

M.setup = function()
	local status_ok, notify = pcall(require, "notify")
	if not status_ok then
		vim.notify("Failed to load module 'notify'", "error")
		return
	end

	notify.setup({
		background_colour = "#" .. vim.api.nvim_get_hl_by_name("Pmenu", "rgb").background,
	})

	vim.notify = notify
end

return M
