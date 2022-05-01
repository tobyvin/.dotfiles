local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

telescope.setup({
	defaults = {
		file_ignore_patterns = { "node_modules", ".git", "dist" },
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--hidden",
			"--iglob",
			"!yarn.lock",
			"--smart-case",
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
