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
			-- disable = {},
			-- updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
			-- persist_queries = false, -- Whether the query persists across vim sessions
			-- keybindings = {
			-- 	toggle_query_editor = "o",
			-- 	toggle_hl_groups = "i",
			-- 	toggle_injected_languages = "t",
			-- 	toggle_anonymous_nodes = "a",
			-- 	toggle_language_display = "I",
			-- 	focus_language = "f",
			-- 	unfocus_language = "F",
			-- 	update = "R",
			-- 	goto_node = "<cr>",
			-- 	show_help = "?",
			-- },
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
					goto_definition_lsp_fallback = "<leader>lgd",
				},
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = { query = "@function.outer", desc = "a function" },
					["if"] = { query = "@function.inner", desc = "inner function" },
					["ia"] = { query = "@statement.inner", desc = "inner statement" },
					["aa"] = { query = "@statement.outer", desc = "a statement" },
					["il"] = { query = "@loop.inner", desc = "inner loop" },
					["al"] = { query = "@loop.outer", desc = "a loop" },
					["ib"] = { query = "@block.inner", desc = "inner block" },
					["ab"] = { query = "@block.outer", desc = "a block" },
					["ic"] = { query = "@class.inner", desc = "inner class" },
					["ac"] = { query = "@class.outer", desc = "a class" },
					["a/"] = { query = "@comment.outer", desc = "a comment" },
					["ii"] = { query = "@conditional.inner", desc = "inner conditional" },
					["ai"] = { query = "@conditional.outer", desc = "a conditional" },
					["iv"] = { query = "@parameter.inner", desc = "inner parameter" },
					["av"] = { query = "@parameter.outer", desc = "a parameter" },
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
