local M = {
	"simrat39/rust-tools.nvim",
	ft = "rust",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",
		"mfussenegger/nvim-dap",
	},
}

function M.init()
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
			local external_docs = require("rust-tools").external_docs.open_external_docs
			local expand_macro = require("rust-tools").expand_macro.expand_macro
			local hover_actions = require("rust-tools").hover_actions.hover_actions

			vim.keymap.set("n", "<leader>dd", debuggables, { desc = "debug", buffer = bufnr })
			vim.keymap.set("n", "<leader>tt", runnables, { desc = "test", buffer = bufnr })
			vim.keymap.set("n", "<leader>lo", open_cargo_toml, { desc = "open Cargo.toml", buffer = bufnr })
			vim.keymap.set("n", "<leader>le", expand_macro, { desc = "expand macro", buffer = bufnr })

			local utils = require("tobyvin.utils")
			utils.documentation.register("rust", external_docs)
			utils.hover.register(hover_actions, { desc = "rust-tools hover actions", buffer = bufnr, priority = 10 })
		end,
	})
end

function M.config()
	require("rust-tools").setup({
		tools = {
			hover_actions = {
				border = "single",
			},
		},
		server = require("tobyvin.lsp.configs").rust_analyzer,
		dap = { adapter = require("tobyvin.plugins.dap.adapters").codelldb },
	})
end

return M
