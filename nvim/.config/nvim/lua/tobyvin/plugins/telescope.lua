local utils = require("tobyvin.utils")
local M = {}

M.frecency_sorter = function()
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
	telescope.load_extension("dap")
	telescope.load_extension("file_browser")
	telescope.load_extension("live_grep_args")

	local pickers = setmetatable(require("telescope.builtin"), {
		__index = function(_, k)
			for _, extension in pairs(telescope.extensions) do
				if extension[k] then
					return extension[k]
				end
			end
			vim.notify(string.format("[Telescope] extension not found: &s", k), vim.log.levels.WARN)
			return function() end
		end,
	})

	utils.keymap.group("n", "<leader>f", { desc = "find" })

	vim.keymap.set("n", "<leader>fa", pickers.autocommands, { desc = "autocommands" })
	vim.keymap.set("n", "<leader>fb", pickers.buffers, { desc = "buffers" })
	vim.keymap.set("n", "<leader>fc", pickers.commands, { desc = "commands" })
	vim.keymap.set("n", "<leader>fC", pickers.command_history, { desc = "command history" })
	vim.keymap.set("n", "<leader>fd", pickers.file_browser, { desc = "file browser" })
	vim.keymap.set("n", "<leader>ff", pickers.find_files, { desc = "find files" })
	vim.keymap.set("n", "<leader>fF", pickers.filetypes, { desc = "filetypes" })
	vim.keymap.set("n", "<leader>fg", pickers.live_grep_args, { desc = "live grep" })
	vim.keymap.set("n", "<leader>fh", pickers.help_tags, { desc = "help" })
	vim.keymap.set("n", "<leader>fH", pickers.highlights, { desc = "highlights" })
	vim.keymap.set("n", "<leader>fj", pickers.jumplist, { desc = "jumplist" })
	vim.keymap.set("n", "<leader>fk", pickers.keymaps, { desc = "keymaps" })
	vim.keymap.set("n", "<leader>fl", pickers.loclist, { desc = "loclist" })
	vim.keymap.set("n", "<leader>fm", pickers.marks, { desc = "marks" })
	vim.keymap.set("n", "<leader>fM", pickers.man_pages, { desc = "man pages" })
	vim.keymap.set("n", "<leader>fo", pickers.oldfiles, { desc = "old files" })
	vim.keymap.set("n", "<leader>fp", pickers.pickers, { desc = "pickers" })
	vim.keymap.set("n", "<leader>fr", pickers.resume, { desc = "resume" })
	vim.keymap.set("n", "<leader>fR", pickers.reloader, { desc = "reloader" })
	vim.keymap.set("n", "<leader>fs", pickers.spell_suggest, { desc = "spell suggest" })
	vim.keymap.set("n", "<leader>fS", pickers.search_history, { desc = "search history" })
	vim.keymap.set("n", "<leader>ft", pickers.tags, { desc = "tags" })
	vim.keymap.set("n", "<leader>ft", pickers.colorscheme, { desc = "colorscheme" })
	vim.keymap.set("n", "<leader>fv", pickers.vim_options, { desc = "vim options" })
	vim.keymap.set("n", "<leader>f'", pickers.registers, { desc = "registers" })
	vim.keymap.set("n", "<leader>dd", pickers.configurations, { desc = "configurations" })
	vim.keymap.set("n", "<leader>dC", pickers.commands, { desc = "commands" })
	vim.keymap.set("n", "<leader>dl", pickers.list_breakpoints, { desc = "list breakpoints" })
	vim.keymap.set("n", "<leader>dv", pickers.variables, { desc = "variables" })
	vim.keymap.set("n", "<leader>df", pickers.frames, { desc = "frames" })

	vim.api.nvim_create_autocmd("User", {
		group = vim.api.nvim_create_augroup("tobyvin_telescope_lsp", { clear = true }),
		pattern = "LspAttach",
		desc = "Setup telescope lsp keymaps",
		callback = function(args)
			vim.keymap.set("n", "<leader>fe", pickers.diagnostics, { desc = "diagnostics", buffer = args.buf })
		end,
	})

	vim.api.nvim_create_autocmd("User", {
		group = vim.api.nvim_create_augroup("tobyvin_telescope_git", { clear = true }),
		pattern = "GitAttach",
		desc = "Setup telescope git keymaps",
		callback = function(args)
			local bufnr = vim.F.if_nil(args.data.buf, args.buf)
			vim.keymap.set("n", "<leader>gb", pickers.git_branches, { desc = "branches", buffer = bufnr })
			vim.keymap.set("n", "<leader>gc", pickers.git_commits, { desc = "commits", buffer = bufnr })
			vim.keymap.set("n", "<leader>gd", pickers.git_status, { desc = "status", buffer = bufnr })
		end,
	})
end

return M
