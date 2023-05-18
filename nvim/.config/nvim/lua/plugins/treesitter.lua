local M = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = "BufReadPost",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"JoosepAlviste/nvim-ts-context-commentstring",
		"mfussenegger/nvim-ts-hint-textobject",
	},
	opts = {
		ensure_installed = {
			"bash",
			"c",
			"cmake",
			"cpp",
			"c_sharp",
			"css",
			"dap_repl",
			"diff",
			"gitignore",
			"go",
			"graphql",
			"html",
			"htmldjango",
			"java",
			"javascript",
			"jsdoc",
			"jsonc",
			"json",
			"latex",
			"lua",
			"make",
			"markdown",
			"markdown_inline",
			"python",
			"query",
			"regex",
			"ron",
			"rust",
			"scss",
			"sql",
			"svelte",
			"teal",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vue",
			"yaml",
		},
		indent = {
			enable = true,
		},
		highlight = {
			enable = true,
		},
		textobjects = {
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]p"] = "@parameter.inner",
					["]f"] = "@function.outer",
					["]]"] = "@class.outer",
				},
				goto_next_end = {
					["]F"] = "@function.outer",
					["]["] = "@class.outer",
				},
				goto_previous_start = {
					["[p"] = "@parameter.inner",
					["[f"] = "@function.outer",
					["[["] = "@class.outer",
				},
				goto_previous_end = {
					["[F"] = "@function.outer",
					["[]"] = "@class.outer",
				},
			},

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
			enable_autocmd = false,
			config = {
				c = "// %s",
				lua = "-- %s",
			},
		},
	},
}

function M:config(opts)
	require("nvim-treesitter.configs").setup(opts)

	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
	vim.opt.foldenable = false
end

return M
