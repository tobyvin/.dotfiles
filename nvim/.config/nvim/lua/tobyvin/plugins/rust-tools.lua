local M = {
	"simrat39/rust-tools.nvim",
	ft = "rust",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",
		"mfussenegger/nvim-dap",
	},
	config = {
		tools = {
			hover_actions = {
				border = "single",
			},
		},
		server = require("tobyvin.lsp.configs").rust_analyzer,
		dap = { adapter = require("tobyvin.plugins.dap.adapters").codelldb },
	},
}

function M.init()
	require("tobyvin.lsp.configs").rust_analyzer = nil

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("tobyvin_rust-tools", { clear = true }),
		desc = "setup rust-tools",
		callback = function(args)
			local bufnr = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client.name ~= "rust_analyzer" then
				return
			end

			local runnables = require("rust-tools").runnables.runnables
			local debuggables = require("rust-tools").debuggables.debuggables
			local open_cargo_toml = require("rust-tools").open_cargo_toml.open_cargo_toml
			local expand_macro = require("rust-tools").expand_macro.expand_macro
			local ssr = require("rust-tools").ssr.ssr

			vim.keymap.set("n", "<leader>dd", debuggables, { desc = "debug", buffer = bufnr })
			vim.keymap.set("n", "<leader>tt", runnables, { desc = "test", buffer = bufnr })
			vim.keymap.set("n", "<leader>lo", open_cargo_toml, { desc = "open Cargo.toml", buffer = bufnr })
			vim.keymap.set("n", "<leader>le", expand_macro, { desc = "expand macro", buffer = bufnr })
			vim.keymap.set("n", "<leader>rs", ssr, { desc = "ssr", buffer = bufnr })

			vim.lsp.handlers["textDocument/hover"] = require("rust-tools.hover_actions").handler
		end,
	})
end

return M
