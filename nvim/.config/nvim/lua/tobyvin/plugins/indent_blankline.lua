local M = {}

M.setup = function()
	local status_ok, indent_blankline = pcall(require, "indent_blankline")
	if not status_ok then
		vim.notify("Failed to load module 'indent_blankline'", "error")
		return
	end

	vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { fg = "#E06C75", nocombine = true })
	vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { fg = "#E5C07B", nocombine = true })
	vim.api.nvim_set_hl(0, "IndentBlanklineIndent3", { fg = "#98C379", nocombine = true })
	vim.api.nvim_set_hl(0, "IndentBlanklineIndent4", { fg = "#56B6C2", nocombine = true })
	vim.api.nvim_set_hl(0, "IndentBlanklineIndent5", { fg = "#61AFEF", nocombine = true })
	vim.api.nvim_set_hl(0, "IndentBlanklineIndent6", { fg = "#C678DD", nocombine = true })

	indent_blankline.setup({
		context_highlight_list = {
			"IndentBlanklineIndent1",
			"IndentBlanklineIndent2",
			"IndentBlanklineIndent3",
			"IndentBlanklineIndent4",
			"IndentBlanklineIndent5",
			"IndentBlanklineIndent6",
		},
		show_current_context = true,
		-- show_current_context_start = true,
		-- show_end_of_line = true,
		use_treesitter = true,
		use_treesitter_scope = true,
	})
end

return M
