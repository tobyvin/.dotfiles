local utils = require("tobyvin.utils")
local M = {}

M.get_frecency_sorter = function()
	local ext = require("telescope._extensions")
	local _ = require("telescope.builtin")
	local frecency_db = require("telescope._extensions.frecency.db_client")

	local fzf = ext.manager.fzf
	local fzf_sorter = fzf.native_fzf_sorter()

	fzf_sorter.default_scoring_function = fzf_sorter.scoring_function
	fzf_sorter.default_start = fzf_sorter.start

	fzf_sorter.scoring_function = function(self, prompt, line, entry)
		if prompt == nil or prompt == "" then
			for _, file_entry in ipairs(self.state.frecency) do
				local filepath = entry.cwd .. "/" .. entry.value
				if file_entry.filename == filepath then
					return 9999 - file_entry.score
				end
			end
			return 9999
		end
		return self.default_scoring_function(self, prompt, line, entry)
	end

	fzf_sorter.start = function(self, prompt)
		self.default_start(self, prompt)
		if not self.state.frecency then
			self.state.frecency = frecency_db.get_file_scores()
		end
	end
	return fzf_sorter
end

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
			file_sorter = M.get_frecency_sorter(),
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
		extensions = {},
	})

	-- Extensions
	telescope.load_extension("fzf")
	telescope.load_extension("frecency")
	telescope.load_extension("dap")

	local builtins = require("telescope.builtin")
	local frecency = telescope.extensions.frecency
	local dap = telescope.extensions.dap

	utils.keymap.group("n", "<leader>f", { desc = "Find" })

	vim.keymap.set("n", "<leader>fa", builtins.autocommands, { desc = "Autocommands" })
	vim.keymap.set("n", "<leader>fb", builtins.buffers, { desc = "Buffers" })
	vim.keymap.set("n", "<leader>fc", builtins.commands, { desc = "Commands" })
	vim.keymap.set("n", "<leader>fC", builtins.command_history, { desc = "Command History" })
	vim.keymap.set("n", "<leader>fe", frecency.frecency, { desc = "Frecency" })
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

	vim.keymap.set("n", "<leader>dd", dap.configurations, { desc = "DAP Configurations" })
	vim.keymap.set("n", "<leader>dC", dap.commands, { desc = "DAP Commands" })
	vim.keymap.set("n", "<leader>dl", dap.list_breakpoints, { desc = "List Breakpoints" })
	vim.keymap.set("n", "<leader>dv", dap.variables, { desc = "List variables" })
	vim.keymap.set("n", "<leader>df", dap.frames, { desc = "List Frames" })

	vim.api.nvim_create_autocmd("User", {
		group = vim.api.nvim_create_augroup("tobyvin_telescope", { clear = true }),
		pattern = "GitAttach",
		callback = function(args)
			telescope.load_extension("git_worktree")
			local wt = telescope.extensions.git_worktree
			local bufnr = vim.F.if_nil(args.data.buf, args.buf)
			vim.keymap.set("n", "<leader>gb", builtins.git_branches, { desc = "Checkout branch", buffer = bufnr })
			vim.keymap.set("n", "<leader>gc", builtins.git_commits, { desc = "Checkout commit", buffer = bufnr })
			vim.keymap.set("n", "<leader>gd", builtins.git_status, { desc = "Git diffs", buffer = bufnr })
			vim.keymap.set("n", "<leader>gw", wt.git_worktrees, { desc = "Switch worktree", buffer = bufnr })
			vim.keymap.set("n", "<leader>gW", wt.create_git_worktree, { desc = "Create worktree", buffer = bufnr })
		end,
	})
end

return M
