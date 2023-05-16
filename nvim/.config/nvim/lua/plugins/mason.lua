local M = {
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	cmd = {
		"Mason",
		"MasonInstall",
		"MasonUninstall",
		"MasonUninstall",
		"MasonLog",
	},
	dependencies = {
		{ "RubixDev/mason-update-all", config = true },
		{ "williamboman/mason-lspconfig.nvim", config = true },
		{ "jayp0521/mason-null-ls.nvim", version = "*", config = true },
		{ "jayp0521/mason-nvim-dap.nvim", version = "*", config = true },
	},
	opts = {
		ui = {
			border = "single",
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	},
}

return M