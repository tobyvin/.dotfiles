local M = {}

M.setup = function()
	local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
	if not status_ok then
		vim.notify("Failed to load module 'nvim-treesitter'", vim.log.levels.ERROR)
		return
	end

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
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ia"] = "@statement.inner",
					["aa"] = "@statement.outer",
					["il"] = "@loop.inner",
					["al"] = "@loop.outer",
					["ib"] = "@block.inner",
					["ab"] = "@block.outer",
					["ic"] = "@class.inner",
					["ac"] = "@class.outer",
					["a/"] = "@comment.outer",
					["ii"] = "@conditional.inner",
					["ai"] = "@conditional.outer",
					["iv"] = "@parameter.inner",
					["av"] = "@parameter.outer",
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
