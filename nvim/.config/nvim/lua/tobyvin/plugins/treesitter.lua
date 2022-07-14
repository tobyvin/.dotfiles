local M = {}

M.setup = function()
	local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
	if not status_ok then
		vim.notify("Failed to load module 'nvim-treesitter'", "error")
		return
	end

	treesitter.setup({
		ensure_installed = { "c", "lua", "rust", "latex" },
		indent = {
			enable = true,
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		refactor = {
			highlight_definitions = {
				enable = true,
				clear_on_cursor_move = true,
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
				},
			},
		},
		textsubjects = {
			enable = true,
			prev_selection = ",", -- (Optional) keymap to select the previous selection
			keymaps = {
				["."] = "textsubjects-smart",
				["ac"] = "textsubjects-container-outer",
				["ic"] = "textsubjects-container-inner",
			},
		},
	})
end

return M
