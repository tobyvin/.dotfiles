local M = {}

M.setup = function()
	local status_ok, tree_climber = pcall(require, "tree-climber")
	if not status_ok then
		vim.notify("Failed to load module 'tree-climber'", vim.log.levels.ERROR)
		return
	end

	vim.keymap.set({ "n", "v", "o" }, "<s-h>", tree_climber.goto_parent, { desc = "Goto Parent" })
	vim.keymap.set({ "n", "v", "o" }, "<s-l>", tree_climber.goto_child, { desc = "Goto Child" })
	vim.keymap.set({ "n", "v", "o" }, "<s-j>", tree_climber.goto_next, { desc = "Goto Next" })
	vim.keymap.set({ "n", "v", "o" }, "<s-k>", tree_climber.goto_prev, { desc = "Goto Prev" })
end

return M
