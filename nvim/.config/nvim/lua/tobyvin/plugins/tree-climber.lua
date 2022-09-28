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
	vim.keymap.set("n", "<c-k>", tree_climber.swap_prev, { desc = "Swap Prev" })
	vim.keymap.set("n", "<c-j>", tree_climber.swap_next, { desc = "Swap Next" })
end

return M
