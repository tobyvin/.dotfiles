local M = {}

M.setup = function()
	local status_ok, telescope = pcall(require, "telescope")
	if not status_ok then
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
			file_ignore_patterns = { "node_modules", ".git", "dist" },
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
		},
		extensions = {
			project = {
				base_dirs = {
					{ path = "~/src", max_depth = 1 },
				},
				hidden_files = true,
			},
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
			frecency = {
				default_workspace = "CWD",
				workspaces = {
					["src"] = "~/src",
				},
			},
		},
		pickers = {
			find_files = {
				find_command = { "rg", "--files", "--hidden" },
			},
			lsp_references = { theme = "dropdown" },
			lsp_code_actions = { theme = "dropdown" },
			lsp_definitions = { theme = "dropdown" },
			lsp_implementations = { theme = "dropdown" },
			buffers = {
				sort_lastused = true,
			},
		},
	})

	-- Extensions
	telescope.load_extension("frecency")
	telescope.load_extension("fzf")
end

M.project_files = function()
	local opts = {} -- define here if you want to define something
	local ok = pcall(require("telescope.builtin").git_files, opts)
	if not ok then
		require("telescope.builtin").find_files(opts)
	end
end

return M
