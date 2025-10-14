local success, telescope = pcall(require, "telescope")
if not success then
	return
end

telescope.setup({
	defaults = {
		file_ignore_patterns = { "^.git/" },
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--hidden",
			"--smart-case",
			"--trim",
		},
		cache_picker = {
			num_pickers = 10,
		},
		mappings = {
			i = {
				["<Esc>"] = "close",
				["<C-Down>"] = "cycle_history_next",
				["<C-Up>"] = "cycle_history_prev",
			},
		},
	},
	pickers = {
		find_files = {
			find_command = {
				"fd",
				"--type",
				"file",
				"--type",
				"symlink",
				"--hidden",
				"--strip-cwd-prefix",
			},
		},
		oldfiles = {
			only_cwd = true,
		},
		live_grep = {
			theme = "ivy",
		},
		buffers = {
			show_all_buffers = true,
			sort_lastused = true,
			mappings = {
				i = {
					["<C-x>"] = "delete_buffer",
				},
			},
		},
		extensions = {
			live_grep_args = {
				theme = "ivy",
			},
			undo = {},
		},
	},
})

telescope.load_extension("fzf")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fa", builtin.autocommands, { desc = "autocommands" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "buffers" })
vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "commands" })
vim.keymap.set("n", "<leader>fd", builtin.lsp_dynamic_workspace_symbols, { desc = "lsp symbols" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "find files" })
vim.keymap.set("n", "<leader>fF", builtin.filetypes, { desc = "filetypes" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "help" })
vim.keymap.set("n", "<leader>fH", builtin.highlights, { desc = "highlights" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "keymaps" })
vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "marks" })
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "old files" })
vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "resume" })
vim.keymap.set("n", "<leader>gt", builtin.git_status, { desc = "status" })
vim.keymap.set("n", "<leader>fg", telescope.extensions.live_grep_args.live_grep_args, { desc = "live grep" })
vim.keymap.set("n", "<leader>fu", telescope.extensions.undo.undo, { desc = "undo" })
