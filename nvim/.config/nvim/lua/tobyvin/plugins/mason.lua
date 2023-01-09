local M = {
	"williamboman/mason.nvim",
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
		{ "jayp0521/mason-null-ls.nvim", config = true },
		{ "jayp0521/mason-nvim-dap.nvim", config = true },
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
