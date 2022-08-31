local M = {}

M.setup = function()
	local status_ok, undotree = pcall(require, "undotree")
	if not status_ok then
		vim.notify("Failed to load module 'undotree'", "error")
		return
	end

	vim.keymap.set("n", "<leader>u", undotree.toggle, { desc = "Toggle undotree" })
end

return M
