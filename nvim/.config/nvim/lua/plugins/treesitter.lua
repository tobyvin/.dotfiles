---@type LazySpec
local M = {
	"nvim-treesitter/nvim-treesitter",
	version = false,
	build = ":TSUpdate",
	event = "BufReadPre",
	cmd = {
		"TSInstall",
		"TSInstallInfo",
		"TSInstallSync",
		"TSModuleInfo",
		"TSUninstall",
		"TSUpdate",
		"TSUpdateSync",
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	main = "nvim-treesitter.configs",
	opts = {
		ensure_installed = {
			"cmake",
			"cpp",
			"c_sharp",
			"css",
			"comment",
			"diff",
			"gitignore",
			"go",
			"graphql",
			"html",
			"java",
			"javascript",
			"jsdoc",
			"jsonc",
			"json",
			"latex",
			"make",
			"python",
			"regex",
			"ron",
			"rust",
			"scss",
			"sql",
			"svelte",
			"toml",
			"tsx",
			"typescript",
			"typst",
			"vue",
			"yaml",
			"zig",
		},
		-- BUG: Required for TSUpdateSync to work in headless.
		-- Ref: https://github.com/nvim-treesitter/nvim-treesitter/issues/2900
		sync_install = #vim.api.nvim_list_uis() == 0,
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
				},
				goto_next_end = {
					["]F"] = "@function.outer",
				},
				goto_previous_start = {
					["[p"] = "@parameter.inner",
					["[f"] = "@function.outer",
				},
				goto_previous_end = {
					["[F"] = "@function.outer",
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
	},
}

return M
