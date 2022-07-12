local M = {}

M.setup = function()
	local status_ok, indent_blankline = pcall(require, "indent_blankline")
	if not status_ok then
		vim.notify("Failed to load module 'indent_blankline'", "error")
		return
	end

	indent_blankline.setup({
		show_current_context = true,
		-- show_current_context_start = true,
		-- show_end_of_line = true,
		use_treesitter = true,
	})
end

return M
