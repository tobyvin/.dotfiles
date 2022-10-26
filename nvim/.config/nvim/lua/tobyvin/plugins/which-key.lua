local M = {}

M.setup = function()
	local status_ok, which_key = pcall(require, "which-key")
	if not status_ok then
		vim.notify("Failed to load module 'which-key'", vim.log.levels.ERROR)
		return
	end

	which_key.setup({
		plugins = {
			spelling = {
				enabled = true,
			},
		},
		window = {
			border = "single",
		},
		layout = {
			align = "center",
		},
	})
end

return M
