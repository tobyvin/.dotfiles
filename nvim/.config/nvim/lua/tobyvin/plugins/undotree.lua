local M = {}

M.setup = function()
	local status_ok, undotree = pcall(require, "undotree")
	if not status_ok then
		vim.notify("Failed to load module 'undotree'", vim.log.levels.ERROR)
		return
	end

	undotree.setup({
		window = {
			winblend = 0,
		},
	})

	vim.keymap.set("n", "<leader>u", undotree.toggle, { desc = "Undotree" })
end

return M
