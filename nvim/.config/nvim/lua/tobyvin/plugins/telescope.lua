local M = {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"BurntSushi/ripgrep",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-telescope/telescope-live-grep-args.nvim",
		"nvim-telescope/telescope-dap.nvim",
	},
}

function M.config()
	local telescope = require("telescope")

	local actions = require("telescope.actions")

	telescope.setup({
		defaults = {
			borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			mappings = {
				i = {
					["<esc>"] = actions.close,
					["<C-h>"] = actions.which_key,
				},
			},
			file_ignore_patterns = { "^.git/", "^target/" },
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
			history = {
				path = vim.fn.stdpath("data") .. "/databases/telescope_history.sqlite3",
				limit = 100,
			},
			cache_picker = {
				num_pickers = 10,
			},
		},
		pickers = {
			find_files = {
				find_command = { "fd", "--type", "f", "--hidden", "--strip-cwd-prefix" },
			},
			live_grep = { theme = "ivy" },
			buffers = {
				show_all_buffers = true,
				sort_lastused = true,
			},
		},
		extensions = {
			live_grep_args = {
				theme = "ivy",
			},
		},
	})

	-- Extensions
	telescope.load_extension("fzf")
	telescope.load_extension("file_browser")
	telescope.load_extension("live_grep_args")

	local builtins = require("telescope.builtin")
	local extensions = telescope.extensions

	vim.keymap.set("n", "<leader>fa", builtins.autocommands, { desc = "autocommands" })
	vim.keymap.set("n", "<leader>fb", builtins.buffers, { desc = "buffers" })
	vim.keymap.set("n", "<leader>fc", builtins.commands, { desc = "commands" })
	vim.keymap.set("n", "<leader>fC", builtins.command_history, { desc = "command history" })
	vim.keymap.set("n", "<leader>fd", extensions.file_browser.file_browser, { desc = "file browser" })
	vim.keymap.set("n", "<leader>fe", builtins.diagnostics, { desc = "diagnostics" })
	vim.keymap.set("n", "<leader>ff", builtins.find_files, { desc = "find files" })
	vim.keymap.set("n", "<leader>fF", builtins.filetypes, { desc = "filetypes" })
	vim.keymap.set("n", "<leader>fg", extensions.live_grep_args.live_grep_args, { desc = "live grep" })
	vim.keymap.set("n", "<leader>fh", builtins.help_tags, { desc = "help" })
	vim.keymap.set("n", "<leader>fH", builtins.highlights, { desc = "highlights" })
	vim.keymap.set("n", "<leader>fj", builtins.jumplist, { desc = "jumplist" })
	vim.keymap.set("n", "<leader>fk", builtins.keymaps, { desc = "keymaps" })
	vim.keymap.set("n", "<leader>fl", builtins.loclist, { desc = "loclist" })
	vim.keymap.set("n", "<leader>fm", builtins.marks, { desc = "marks" })
	vim.keymap.set("n", "<leader>fM", builtins.man_pages, { desc = "man pages" })
	vim.keymap.set("n", "<leader>fo", builtins.oldfiles, { desc = "old files" })
	vim.keymap.set("n", "<leader>fp", builtins.pickers, { desc = "pickers" })
	vim.keymap.set("n", "<leader>fr", builtins.resume, { desc = "resume" })
	vim.keymap.set("n", "<leader>fR", builtins.reloader, { desc = "reloader" })
	vim.keymap.set("n", "<leader>fs", builtins.spell_suggest, { desc = "spell suggest" })
	vim.keymap.set("n", "<leader>fS", builtins.search_history, { desc = "search history" })
	vim.keymap.set("n", "<leader>ft", builtins.tags, { desc = "tags" })
	vim.keymap.set("n", "<leader>ft", builtins.colorscheme, { desc = "colorscheme" })
	vim.keymap.set("n", "<leader>fv", builtins.vim_options, { desc = "vim options" })
	vim.keymap.set("n", "<leader>f'", builtins.registers, { desc = "registers" })
	vim.keymap.set("n", "<leader>gb", builtins.git_branches, { desc = "branches" })
	vim.keymap.set("n", "<leader>gc", builtins.git_bcommits, { desc = "bcommits" })
	vim.keymap.set("n", "<leader>gC", builtins.git_commits, { desc = "commits" })
	vim.keymap.set("n", "<leader>gf", builtins.git_files, { desc = "files" })
	vim.keymap.set("n", "<leader>gt", builtins.git_status, { desc = "status" })
	vim.keymap.set("n", "<leader>gT", builtins.git_stash, { desc = "stash" })
end

return M
