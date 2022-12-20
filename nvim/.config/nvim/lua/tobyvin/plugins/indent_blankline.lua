local M = {
	"lukas-reineke/indent-blankline.nvim",
}

function M.config()
	local indent_blankline = require("indent_blankline")

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
		space_char_blankline = " ",
		show_end_of_line = true,
		show_current_context = true,
		use_treesitter = true,
		use_treesitter_scope = true,
	})
end

return M
