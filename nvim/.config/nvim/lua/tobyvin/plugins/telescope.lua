local M = {}

M.setup = function()
	local status_ok, telescope = pcall(require, "telescope")
	if not status_ok then
		vim.notify("Failed to load module 'telescope'", "error")
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
	telescope.load_extension("packer")
	telescope.load_extension("gh")

	local builtins = require("telescope.builtin")

	local nmap_find = require("tobyvin.utils").create_map_group("n", "<leader>f", { desc = "Find" })
	nmap_find("a", builtins.autocommands, { desc = "Autocommands" })
	nmap_find("b", builtins.buffers, { desc = "Buffers" })
	nmap_find("c", builtins.commands, { desc = "Commands" })
	nmap_find("C", builtins.command_history, { desc = "Command History" })
	nmap_find("f", builtins.find_files, { desc = "Files" })
	nmap_find("F", builtins.filetypes, { desc = "Filetypes" })
	nmap_find("g", builtins.live_grep, { desc = "Grep" })
	nmap_find("h", builtins.help_tags, { desc = "Help" })
	nmap_find("H", builtins.highlights, { desc = "Highlights" })
	nmap_find("j", builtins.jumplist, { desc = "Jumplist" })
	nmap_find("k", builtins.keymaps, { desc = "Keymaps" })
	nmap_find("l", builtins.loclist, { desc = "Loclist" })
	nmap_find("m", builtins.marks, { desc = "Marks" })
	nmap_find("M", builtins.man_pages, { desc = "Man Pages" })
	nmap_find("o", builtins.oldfiles, { desc = "Old Files" })
	nmap_find("p", builtins.pickers, { desc = "Pickers" })
	nmap_find("r", builtins.resume, { desc = "Resume" })
	nmap_find("R", builtins.reloader, { desc = "Reloader" })
	nmap_find("s", builtins.spell_suggest, { desc = "Spell Suggest" })
	nmap_find("S", builtins.search_history, { desc = "Search History" })
	nmap_find("t", builtins.tags, { desc = "Tags" })
	nmap_find("t", builtins.colorscheme, { desc = "Colorscheme" })
	nmap_find("v", builtins.vim_options, { desc = "Vim Options" })
	nmap_find("'", builtins.registers, { desc = "Registers" })

	local nmap_git = require("tobyvin.utils").create_map_group("n", "<leader>g", { desc = "Git" })
	nmap_git("b", builtins.git_branches, { desc = "Checkout branch" })
	nmap_git("c", builtins.git_commits, { desc = "Checkout commit" })
	nmap_git("o", builtins.git_status, { desc = "Open changed file" })

	local nmap_git_wt = require("tobyvin.utils").create_map_group("n", "<leader>gw", { desc = "Worktree" })
	nmap_git_wt("s", telescope.extensions.git_worktree.git_worktrees, { desc = "Switch worktree" })
	nmap_git_wt("c", telescope.extensions.git_worktree.create_git_worktree, { desc = "Create worktree" })

	local nmap_git_gh = require("tobyvin.utils").create_map_group("n", "<leader>gG", { desc = "Github" })
	nmap_git_gh("i", telescope.extensions.gh.issues, { desc = "Issues" })
	nmap_git_gh("p", telescope.extensions.gh.pull_request, { desc = "Pull request" })
	nmap_git_gh("g", telescope.extensions.gh.gist, { desc = "Gist" })
	nmap_git_gh("r", telescope.extensions.gh.run, { desc = "Run" })

	local nmap_packer = require("tobyvin.utils").create_map_group("n", "<leader>p", { desc = "Packer" })
	nmap_packer("f", telescope.extensions.packer.packer, { desc = "Find plugins" })
end

return M
