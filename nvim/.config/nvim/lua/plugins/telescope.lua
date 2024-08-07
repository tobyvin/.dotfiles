---@type LazySpec
local telescope = {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
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
						["<C-x>"] = "delete_buffer",
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

function telescope:init()
	local builtin = function(name)
		return function()
			require("telescope.builtin")[name]()
		end
	end

	vim.keymap.set("n", "<leader>fa", builtin("autocommands"), { desc = "autocommands" })
	vim.keymap.set("n", "<leader>fb", builtin("buffers"), { desc = "buffers" })
	vim.keymap.set("n", "<leader>fc", builtin("commands"), { desc = "commands" })
	vim.keymap.set("n", "<leader>fd", builtin("lsp_dynamic_workspace_symbols"), { desc = "lsp symbols" })
	vim.keymap.set("n", "<leader>ff", builtin("find_files"), { desc = "find files" })
	vim.keymap.set("n", "<leader>fF", builtin("filetypes"), { desc = "filetypes" })
	vim.keymap.set("n", "<leader>fh", builtin("help_tags"), { desc = "help" })
	vim.keymap.set("n", "<leader>fH", builtin("highlights"), { desc = "highlights" })
	vim.keymap.set("n", "<leader>fk", builtin("keymaps"), { desc = "keymaps" })
	vim.keymap.set("n", "<leader>fm", builtin("marks"), { desc = "marks" })
	vim.keymap.set("n", "<leader>fo", builtin("oldfiles"), { desc = "old files" })
	vim.keymap.set("n", "<leader>fr", builtin("resume"), { desc = "resume" })
	vim.keymap.set("n", "<leader>gt", builtin("git_status"), { desc = "status" })
end

---@type LazySpec
local telescope_live_grep_args = {
	"nvim-telescope/telescope-live-grep-args.nvim",
}

function telescope_live_grep_args:init()
	vim.keymap.set("n", "<leader>fg", function()
		require("telescope").extensions.live_grep_args.live_grep_args()
	end, { desc = "live grep" })

	vim.keymap.set("v", "<leader>fg", function()
		require("telescope-live-grep-args.shortcuts").grep_visual_selection()
	end, { desc = "live grep selection" })
end

---@type LazySpec
local telescope_undo = {
	"debugloop/telescope-undo.nvim",
	specs = {
		"nvim-telescope/telescope.nvim",
		opts = {
			extensions = {
				undo = {},
			},
		},
	},
}

function telescope_undo:init()
	vim.keymap.set("n", "<leader>fu", function()
		require("telescope").extensions.undo.undo()
	end, { desc = "undo" })
end

---@type LazySpec
local M = {
	"nvim-lua/plenary.nvim",
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	telescope_undo,
	telescope_live_grep_args,
	telescope,
}

return M
