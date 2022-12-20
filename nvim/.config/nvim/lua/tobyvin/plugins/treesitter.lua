local M = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = "BufReadPost",
	dependencies = {
		"nvim-treesitter/playground",
		"nvim-treesitter/nvim-treesitter-textobjects",
		"JoosepAlviste/nvim-ts-context-commentstring",
		"mfussenegger/nvim-ts-hint-textobject",
	},
}

function M.config()
	local treesitter = require("nvim-treesitter.configs")

	treesitter.setup({
		ensure_installed = "all",
		indent = {
			enable = true,
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = { "markdown" },
			disable = function(_, bufnr)
				-- TODO: temp solution to ts highlighting screwing up formatting
				return vim.api.nvim_buf_line_count(bufnr) > 2500 or vim.bo[bufnr].filetype == "help"
			end,
		},
		playground = {
			enable = true,
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["ib"] = "@block.inner",
					["ab"] = "@block.outer",
					["ie"] = "@call.inner",
					["ae"] = "@call.outer",
					["ic"] = "@class.inner",
					["ac"] = "@class.outer",
					["i/"] = "@comment.inner",
					["a/"] = "@comment.outer",
					["ii"] = "@conditional.inner",
					["ai"] = "@conditional.outer",
					["if"] = "@function.inner",
					["af"] = "@function.outer",
					["il"] = "@loop.inner",
					["al"] = "@loop.outer",
					["ia"] = "@parameter.inner",
					["aa"] = "@parameter.outer",
					["iv"] = "@statement.inner",
					["av"] = "@statement.outer",
				},
			},
		},
		context_commentstring = {
			enable = true,
		},
	})
end

return M
