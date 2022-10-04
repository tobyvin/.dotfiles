local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	local status_ok, telescope = pcall(require, "telescope")
	if not status_ok then
		vim.notify("Failed to load module 'telescope'", vim.log.levels.ERROR)
		return
	end

	local actions = require("telescope.actions")

	telescope.setup({
		defaults = {
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
				"-u",
			},
			layout_strategy = "flex",
			scroll_strategy = "cycle",
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
				theme = "dropdown",
				find_command = { "fd", "--type", "f", "--hidden", "--strip-cwd-prefix" },
			},
			live_grep = { theme = "ivy" },
			lsp_references = { theme = "dropdown" },
			lsp_code_actions = { theme = "dropdown" },
			lsp_definitions = { theme = "dropdown" },
			lsp_implementations = { theme = "dropdown" },
			buffers = {
				show_all_buffers = true,
				sort_lastused = true,
			},
		},
	})

	-- Extensions
	telescope.load_extension("smart_history")
	telescope.load_extension("fzf")

	local builtins = require("telescope.builtin")
	local extensions = telescope.extensions

	utils.keymap.group("n", "<leader>f", { desc = "Find" })
	utils.keymap.group("n", "<leader>g", { desc = "Git" })

	vim.keymap.set("n", "<leader>fa", builtins.autocommands, { desc = "Autocommands" })
	vim.keymap.set("n", "<leader>fb", builtins.buffers, { desc = "Buffers" })
	vim.keymap.set("n", "<leader>fc", builtins.commands, { desc = "Commands" })
	vim.keymap.set("n", "<leader>fC", builtins.command_history, { desc = "Command History" })
	vim.keymap.set("n", "<leader>ff", builtins.find_files, { desc = "Files" })
	vim.keymap.set("n", "<leader>fF", builtins.filetypes, { desc = "Filetypes" })
	vim.keymap.set("n", "<leader>fg", builtins.live_grep, { desc = "Grep" })
	vim.keymap.set("n", "<leader>fh", builtins.help_tags, { desc = "Help" })
	vim.keymap.set("n", "<leader>fH", builtins.highlights, { desc = "Highlights" })
	vim.keymap.set("n", "<leader>fj", builtins.jumplist, { desc = "Jumplist" })
	vim.keymap.set("n", "<leader>fk", builtins.keymaps, { desc = "Keymaps" })
	vim.keymap.set("n", "<leader>fl", builtins.loclist, { desc = "Loclist" })
	vim.keymap.set("n", "<leader>fm", builtins.marks, { desc = "Marks" })
	vim.keymap.set("n", "<leader>fM", builtins.man_pages, { desc = "Man Pages" })
	vim.keymap.set("n", "<leader>fo", builtins.oldfiles, { desc = "Old Files" })
	vim.keymap.set("n", "<leader>fp", builtins.pickers, { desc = "Pickers" })
	vim.keymap.set("n", "<leader>fr", builtins.resume, { desc = "Resume" })
	vim.keymap.set("n", "<leader>fR", builtins.reloader, { desc = "Reloader" })
	vim.keymap.set("n", "<leader>fs", builtins.spell_suggest, { desc = "Spell Suggest" })
	vim.keymap.set("n", "<leader>fS", builtins.search_history, { desc = "Search History" })
	vim.keymap.set("n", "<leader>ft", builtins.tags, { desc = "Tags" })
	vim.keymap.set("n", "<leader>ft", builtins.colorscheme, { desc = "Colorscheme" })
	vim.keymap.set("n", "<leader>fv", builtins.vim_options, { desc = "Vim Options" })
	vim.keymap.set("n", "<leader>f'", builtins.registers, { desc = "Registers" })
	vim.keymap.set("n", "<leader>gb", builtins.git_branches, { desc = "Checkout branch" })
	vim.keymap.set("n", "<leader>gc", builtins.git_commits, { desc = "Checkout commit" })
	vim.keymap.set("n", "<leader>gd", builtins.git_status, { desc = "Git diffs" })

	telescope.load_extension("git_worktree")
	utils.keymap.group("n", "<leader>gw", { desc = "Worktree" })
	vim.keymap.set("n", "<leader>gw", extensions.git_worktree.git_worktrees, { desc = "Switch worktree" })
	vim.keymap.set("n", "<leader>gW", extensions.git_worktree.create_git_worktree, { desc = "Create worktree" })

	telescope.load_extension("gh")
	utils.keymap.group("n", "<leader>gG", { desc = "Github" })
	vim.keymap.set("n", "<leader>gGi", extensions.gh.issues, { desc = "Issues" })
	vim.keymap.set("n", "<leader>gGp", extensions.gh.pull_request, { desc = "Pull request" })
	vim.keymap.set("n", "<leader>gGg", extensions.gh.gist, { desc = "Gist" })
	vim.keymap.set("n", "<leader>gGr", extensions.gh.run, { desc = "Run" })

	telescope.load_extension("packer")
	utils.keymap.group("n", "<leader>p", { desc = "Packer" })
	vim.keymap.set("n", "<leader>pf", extensions.packer.packer, { desc = "Find plugins" })

	telescope.load_extension("dap")
	vim.keymap.set("n", "<leader>dd", extensions.dap.configurations, { desc = "Configurations" })
	vim.keymap.set("n", "<leader>dC", extensions.dap.commands, { desc = "Commands" })
	vim.keymap.set("n", "<leader>dl", extensions.dap.list_breakpoints, { desc = "List Breakpoints" })
	vim.keymap.set("n", "<leader>dv", extensions.dap.variables, { desc = "Variables" })
	vim.keymap.set("n", "<leader>df", extensions.dap.frames, { desc = "Frames" })
end

return M
