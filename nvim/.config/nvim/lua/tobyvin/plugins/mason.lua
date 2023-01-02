local M = {
	"williamboman/mason.nvim",
	dependencies = {
		"RubixDev/mason-update-all",
		"williamboman/mason-lspconfig.nvim",
		"jayp0521/mason-null-ls.nvim",
		"jayp0521/mason-nvim-dap.nvim",
	},
}

function M.init()
	vim.keymap.set("n", "<leader>i", function()
		require("mason.api.command").Mason()
	end, { desc = "mason" })

	vim.keymap.set("n", "<leader>I", function()
		require("mason.api.command").MasonLog()
	end, { desc = "log" })
end

function M.config()
	require("mason").setup({
		ui = {
			border = "single",
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})

	require("mason-update-all").setup()
	require("mason-lspconfig").setup()
	require("mason-null-ls").setup()
	require("mason-nvim-dap").setup()
end

return M
