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

function M.init()
	local builtin = setmetatable({}, {
		__index = function(_, k)
			return function()
				require("telescope.builtin")[k]()
			end
		end,
	})

	vim.keymap.set("n", "<leader>fa", builtin.autocommands, { desc = "autocommands" })
	vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "buffers" })
	vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "commands" })
	vim.keymap.set("n", "<leader>fC", builtin.command_history, { desc = "command history" })
	vim.keymap.set("n", "<leader>fe", builtin.diagnostics, { desc = "diagnostics" })
	vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "find files" })
	vim.keymap.set("n", "<leader>fF", builtin.filetypes, { desc = "filetypes" })
	vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "help" })
	vim.keymap.set("n", "<leader>fH", builtin.highlights, { desc = "highlights" })
	vim.keymap.set("n", "<leader>fj", builtin.jumplist, { desc = "jumplist" })
	vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "keymaps" })
	vim.keymap.set("n", "<leader>fl", builtin.loclist, { desc = "loclist" })
	vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "marks" })
	vim.keymap.set("n", "<leader>fM", builtin.man_pages, { desc = "man pages" })
	vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "old files" })
	vim.keymap.set("n", "<leader>fp", builtin.pickers, { desc = "pickers" })
	vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "resume" })
	vim.keymap.set("n", "<leader>fR", builtin.reloader, { desc = "reloader" })
	vim.keymap.set("n", "<leader>fs", builtin.spell_suggest, { desc = "spell suggest" })
	vim.keymap.set("n", "<leader>fS", builtin.search_history, { desc = "search history" })
	vim.keymap.set("n", "<leader>ft", builtin.colorscheme, { desc = "colorscheme" })
	vim.keymap.set("n", "<leader>fT", builtin.tags, { desc = "tags" })
	vim.keymap.set("n", "<leader>fv", builtin.vim_options, { desc = "vim options" })
	vim.keymap.set("n", "<leader>f'", builtin.registers, { desc = "registers" })
	vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "branches" })
	vim.keymap.set("n", "<leader>gc", builtin.git_bcommits, { desc = "bcommits" })
	vim.keymap.set("n", "<leader>gC", builtin.git_commits, { desc = "commits" })
	vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "files" })
	vim.keymap.set("n", "<leader>gt", builtin.git_status, { desc = "status" })
	vim.keymap.set("n", "<leader>gT", builtin.git_stash, { desc = "stash" })

	vim.keymap.set("n", "<leader>fd", function()
		require("telescope").extensions.file_browser.file_browser()
	end, { desc = "file browser" })

	vim.keymap.set("n", "<leader>fg", function()
		require("telescope").extensions.live_grep_args.live_grep_args()
	end, { desc = "live grep" })
end

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
end

return M
