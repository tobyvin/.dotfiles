local M = {}

M.setup = function()
	local status_ok, which_key = pcall(require, "which-key")
	if not status_ok then
		vim.notify("Failed to load module 'which-key'", "error")
		return
	end

	which_key.setup({
		plugins = {
			spelling = {
				enabled = true,
			},
		},
		window = {
			border = "rounded",
		},
		layout = {
			align = "center",
		},
	})
end

return M
