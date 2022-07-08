local M = {}

M.setup = function()
	local status_ok, crates = pcall(require, "crates")
	if not status_ok then
		vim.notify("Failed to load module 'crates'", "error")
		return
	end

	crates.setup({
		null_ls = {
			enabled = true,
		},
	})
end

return M
