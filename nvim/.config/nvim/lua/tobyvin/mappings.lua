local mappings = {
	{
		-- NORMAL mode
		opts = {},
		mappings = {
			["<leader>"] = {
				c = { "<cmd>Bdelete!<CR>", "Close Buffer" },
				q = { "<cmd>q<CR>", "Quit" },
				w = { "<cmd>w!<CR>", "Save" },
				-- W = { ":set wrap! linebreak!<CR>", "Toggle Line Wrap" },
				["/"] = { "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>", "Comment" },

				f = {
					name = "Find",
					s = { "<cmd>Telescope session-lens search_session<cr>", "Sessions" },
				},

				m = {
					name = "Markers",
					h = { '<cmd>lua require("harpoon.mark").add_file()<cr>', "Harpoon" },
					u = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', "Harpoon UI" },
				},
				-- r = {
				-- 	name = "Replace",
				-- 	f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Replace Buffer" },
				-- 	r = { "<cmd>lua require('spectre').open()<cr>", "Replace" },
				-- 	w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Replace Word" },
				-- },
			},
		},
	},
	{
		-- VISUAL mode
		opts = {
			mode = "v",
		},
		mappings = {
			-- Ctrl maps
			["<C-/>"] = {
				"<ESC><CMD>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>",
				"Comment",
			},

			-- Prefix "<leader>"
			["<leader>"] = {
				["/"] = {
					"<ESC><CMD>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>",
					"Comment",
				},
			},
		},
	},
	{
		-- INSERT mode
		opts = {
			mode = "i",
		},
		mappings = {
			["<C-h>"] = { "<left>", "Left" },
			["<C-j>"] = { "<up>", "Up" },
			["<C-k>"] = { "<down>", "Down" },
			["<C-l>"] = { "<right>", "Right" },
		},
	},
}

local ok, which_key = pcall(require, "which-key")
if ok then
	for i, m in ipairs(mappings) do
		which_key.register(m.mappings, m.opts)
	end
end
