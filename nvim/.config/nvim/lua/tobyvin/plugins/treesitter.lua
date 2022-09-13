local M = {}

M.setup = function()
	local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
	if not status_ok then
		vim.notify("Failed to load module 'nvim-treesitter'", "error")
		return
	end

	treesitter.setup({
		ensure_installed = "all",
		indent = {
			enable = true,
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = { "latex" },
			disable = function(_, bufnr)
				return vim.api.nvim_buf_line_count(bufnr) > 2500
			end,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<CR>",
				scope_incremental = "<CR>",
				node_incremental = "<TAB>",
				node_decremental = "<S-TAB>",
			},
		},
		playground = {
			enable = true,
		},
		refactor = {
			highlight_definitions = {
				enable = true,
				clear_on_cursor_move = true,
			},
			smart_rename = {
				enable = true,
				keymaps = {
					smart_rename = "<leader>lr",
				},
			},
			navigation = {
				enable = true,
				keymaps = {
					goto_definition_lsp_fallback = "gd",
				},
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer", -- { query = "@function.outer", desc = "a function" },
					["if"] = "@function.inner", -- { query = "@function.inner", desc = "inner function" },
					["ia"] = "@statement.inner", -- { query = "@statement.inner", desc = "inner statement" },
					["aa"] = "@statement.outer", -- { query = "@statement.outer", desc = "a statement" },
					["il"] = "@loop.inner", -- { query = "@loop.inner", desc = "inner loop" },
					["al"] = "@loop.outer", -- { query = "@loop.outer", desc = "a loop" },
					["ib"] = "@block.inner", -- { query = "@block.inner", desc = "inner block" },
					["ab"] = "@block.outer", -- { query = "@block.outer", desc = "a block" },
					["ic"] = "@class.inner", -- { query = "@class.inner", desc = "inner class" },
					["ac"] = "@class.outer", -- { query = "@class.outer", desc = "a class" },
					["a/"] = "@comment.outer", -- { query = "@comment.outer", desc = "a comment" },
					["ii"] = "@conditional.inner", -- { query = "@conditional.inner", desc = "inner conditional" },
					["ai"] = "@conditional.outer", -- { query = "@conditional.outer", desc = "a conditional" },
					["iv"] = "@parameter.inner", -- { query = "@parameter.inner", desc = "inner parameter" },
					["av"] = "@parameter.outer", -- { query = "@parameter.outer", desc = "a parameter" },
				},
			},
		},
		textsubjects = {
			enable = true,
			prev_selection = ",", -- (Optional) keymap to select the previous selection
			keymaps = {
				["."] = "textsubjects-smart",
				["a."] = "textsubjects-container-outer",
				["i."] = "textsubjects-container-inner",
			},
		},
	})
end

return M
