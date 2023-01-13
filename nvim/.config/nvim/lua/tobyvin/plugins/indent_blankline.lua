local M = {
	"lukas-reineke/indent-blankline.nvim",
	version = "*",
	event = "BufReadPre",
}

function M.init()
	vim.api.nvim_set_hl(0, "IndentBlanklineContext1", { fg = "Red", default = true })
	vim.api.nvim_set_hl(0, "IndentBlanklineContext2", { fg = "Brown", default = true })
	vim.api.nvim_set_hl(0, "IndentBlanklineContext3", { fg = "Yellow", default = true })
	vim.api.nvim_set_hl(0, "IndentBlanklineContext4", { fg = "Green", default = true })
	vim.api.nvim_set_hl(0, "IndentBlanklineContext5", { fg = "Cyan", default = true })
	vim.api.nvim_set_hl(0, "IndentBlanklineContext6", { fg = "Blue", default = true })
	vim.api.nvim_set_hl(0, "IndentBlanklineContext7", { fg = "Magenta", default = true })
end

function M.config()
	local indent_blankline = require("indent_blankline")

	indent_blankline.setup({
		context_highlight_list = {
			"IndentBlanklineContext1",
			"IndentBlanklineContext2",
			"IndentBlanklineContext3",
			"IndentBlanklineContext4",
			"IndentBlanklineContext5",
			"IndentBlanklineContext6",
			"IndentBlanklineContext7",
		},
		space_char_blankline = " ",
		show_end_of_line = true,
		show_current_context = true,
		use_treesitter = true,
		use_treesitter_scope = true,
	})
end

return M
