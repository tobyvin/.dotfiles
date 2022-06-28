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
					["<C-h>"] = "which_key",
				},
			},
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
		extensions = {
			frecency = {
				default_workspace = "CWD",
				workspaces = {
					["src"] = "~/src",
				},
				theme = "dropdown",
			},
		},
	})

	-- Extensions
	telescope.load_extension("smart_history")
	telescope.load_extension("fzf")
	telescope.load_extension("frecency")
	telescope.load_extension("packer")
	telescope.load_extension("gh")

	local builtins = require("telescope.builtin")

	local nmap_find = require("tobyvin.utils").create_map_group("n", "<leader>f", "Find")
	nmap_find("b", builtins.buffers, { desc = "Buffers" })
	nmap_find("C", builtins.commands, { desc = "Commands" })
	nmap_find("f", builtins.find_files, { desc = "Find files" })
	nmap_find("g", builtins.live_grep, { desc = "Find Text" })
	nmap_find("h", builtins.help_tags, { desc = "Help" })
	nmap_find("k", builtins.keymaps, { desc = "Keymaps" })
	nmap_find("l", builtins.resume, { desc = "Last Search" })
	nmap_find("m", builtins.man_pages, { desc = "Man Pages" })
	nmap_find("r", builtins.oldfiles, { desc = "Recent File" })
	nmap_find("R", builtins.registers, { desc = "Registers" })
	nmap_find("t", builtins.colorscheme, { desc = "Colorscheme" })
	nmap_find("e", telescope.extensions.frecency.frecency, { desc = "Frecency" })
	nmap_find("p", telescope.extensions.packer.packer, { desc = "Packer" })

	local nmap_git = require("tobyvin.utils").create_map_group("n", "<leader>g", "Git")
	nmap_git("b", builtins.git_branches, { desc = "Checkout branch" })
	nmap_git("c", builtins.git_commits, { desc = "Checkout commit" })
	nmap_git("o", builtins.git_status, { desc = "Open changed file" })

	local nmap_git_wt = require("tobyvin.utils").create_map_group("n", "<leader>gw", "Worktree")
	nmap_git_wt("s", telescope.extensions.git_worktree.git_worktrees, { desc = "Switch worktree" })
	nmap_git_wt("c", telescope.extensions.git_worktree.create_git_worktree, { desc = "Create worktree" })

	local nmap_git_gh = require("tobyvin.utils").create_map_group("n", "<leader>gG", "Github")
	nmap_git_gh("i", telescope.extensions.gh.issues, { desc = "Issues" })
	nmap_git_gh("p", telescope.extensions.gh.pull_request, { desc = "Pull request" })
	nmap_git_gh("g", telescope.extensions.gh.gist, { desc = "Gist" })
	nmap_git_gh("r", telescope.extensions.gh.run, { desc = "Run" })
end

M.project_files = function()
	local opts = {} -- define here if you want to define something
	local ok = pcall(require("telescope.builtin").git_files, opts)
	if not ok then
		require("telescope.builtin").find_files(opts)
	end
end

return M
