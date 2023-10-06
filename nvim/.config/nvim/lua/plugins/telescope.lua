---@type LazyPluginSpec
local M = {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"nvim-telescope/telescope-live-grep-args.nvim",
		"nvim-telescope/telescope-dap.nvim",
		"nvim-telescope/telescope-symbols.nvim",
		"debugloop/telescope-undo.nvim",
	},
	opts = {
		defaults = {
			borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
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
					["<C-h>"] = "which_key",
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
					"f",
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
						["<C-d>"] = "delete_buffer",
					},
				},
			},
		},
		extensions = {
			live_grep_args = {
				theme = "ivy",
			},
		},
	},
	keys = {
		"<leader>f",
		"<leader>g",
	},
}

function M:config(opts)
	opts.extensions.undo = {
		mappings = {
			i = {
				["<cr>"] = require("telescope-undo.actions").restore,
				["<C-cr>"] = require("telescope-undo.actions").yank_additions,
				["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
			},
		},
	}

	require("telescope").setup(opts)
	require("telescope").load_extension("fzf")
	require("telescope").load_extension("undo")

	local builtin = require("telescope.builtin")
	local extensions = require("telescope").extensions

	vim.keymap.set("n", "<leader>fa", builtin.autocommands, { desc = "autocommands" })
	vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "buffers" })
	vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "commands" })
	vim.keymap.set("n", "<leader>fC", builtin.command_history, { desc = "command history" })
	vim.keymap.set("n", "<leader>fe", builtin.diagnostics, { desc = "diagnostics" })
	vim.keymap.set("n", "<leader>fd", builtin.lsp_dynamic_workspace_symbols, { desc = "lsp symbols" })
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
	vim.keymap.set("n", "<leader>fP", builtin.pickers, { desc = "pickers" })
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
	vim.keymap.set("n", "<leader>fg", extensions.live_grep_args.live_grep_args, { desc = "live grep" })
	vim.keymap.set("n", "<leader>fu", extensions.undo.undo, { desc = "undo" })

	vim.keymap.set("v", "<leader>fg", function()
		require("telescope-live-grep-args.shortcuts").grep_visual_selection()
	end, { desc = "live grep selection" })
end

return M
