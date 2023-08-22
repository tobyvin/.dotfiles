---@type LazyPluginSpec
local M = {
	"lukas-reineke/indent-blankline.nvim",
	version = "*",
	event = "BufReadPre",
	opts = {
		context_highlight_list = {
			"IndentContext1",
			"IndentContext2",
			"IndentContext3",
			"IndentContext4",
			"IndentContext5",
			"IndentContext6",
			"IndentContext7",
		},
		space_char_blankline = " ",
		show_end_of_line = true,
		show_current_context = true,
		use_treesitter = true,
		use_treesitter_scope = true,
	},
}

function M.init()
	vim.api.nvim_set_hl(0, "IndentContext1", { fg = "Red", default = true })
	vim.api.nvim_set_hl(0, "IndentContext2", { fg = "Brown", default = true })
	vim.api.nvim_set_hl(0, "IndentContext3", { fg = "Yellow", default = true })
	vim.api.nvim_set_hl(0, "IndentContext4", { fg = "Green", default = true })
	vim.api.nvim_set_hl(0, "IndentContext5", { fg = "Cyan", default = true })
	vim.api.nvim_set_hl(0, "IndentContext6", { fg = "Blue", default = true })
	vim.api.nvim_set_hl(0, "IndentContext7", { fg = "Magenta", default = true })
end

return M
