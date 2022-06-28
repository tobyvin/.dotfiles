local status_ok, neo_tree = pcall(require, "neo-tree")
if not status_ok then
	return
end

vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

neo_tree.setup({
	close_if_last_window = true,
	window = {
		mappings = {
			["<space>"] = "none",
			["<2-LeftMouse>"] = "none",
			["<cr>"] = "none",
			["S"] = "none",
			["s"] = "none",
			["t"] = "none",
			["C"] = "none",
			["a"] = "none",
			["A"] = "none",
			["d"] = "none",
			["r"] = "none",
			["y"] = "none",
			["x"] = "none",
			["p"] = "none",
			["c"] = "none",
			["m"] = "none",
			["q"] = "none",
			["R"] = "none",
		},
	},
	filesystem = {
		filtered_items = {
			hide_dotfiles = false,
		},
		use_libuv_file_watcher = true,
		window = {
			mappings = {
				["<bs>"] = "none",
				["."] = "none",
				["H"] = "none",
				["/"] = "none",
				["f"] = "none",
				["<c-x>"] = "none",
			},
		},
	},
	buffers = {
		mappings = {
			["bd"] = "none",
			["<bs>"] = "none",
			["."] = "none",
		},
	},
	git_status = {
		window = {
			mappings = {
				["A"] = "none",
				["gu"] = "none",
				["ga"] = "none",
				["gr"] = "none",
				["gc"] = "none",
				["gp"] = "none",
				["gg"] = "none",
			},
		},
	},
})
