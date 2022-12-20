local M = {
	"simrat39/rust-tools.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",
		"mfussenegger/nvim-dap",
	},
}

function M.config()
	local rust_tools = require("rust-tools")
	local utils = require("tobyvin.utils")
	local lsp = require("tobyvin.lsp")
	local adapters = require("tobyvin.plugins.dap.adapters")

	rust_tools.setup({
		tools = {
			hover_actions = {
				border = "single",
			},
		},
		server = lsp.configs.rust_analyzer,
		dap = { adapter = adapters.codelldb },
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("tobyvin_rust-tools", { clear = true }),
		desc = "setup rust-tools",
		callback = function(args)
			local bufnr = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client.name ~= "rust_analyzer" then
				return
			end

			local runnables = rust_tools.runnables.runnables
			local debuggables = rust_tools.debuggables.debuggables
			local open_cargo_toml = rust_tools.open_cargo_toml.open_cargo_toml
			local external_docs = rust_tools.external_docs.open_external_docs
			local expand_macro = rust_tools.expand_macro.expand_macro
			local hover_actions = rust_tools.hover_actions.hover_actions

			vim.keymap.set("n", "<leader>dd", debuggables, { desc = "debug", buffer = bufnr })
			vim.keymap.set("n", "<leader>tt", runnables, { desc = "test", buffer = bufnr })
			vim.keymap.set("n", "<leader>lo", open_cargo_toml, { desc = "open Cargo.toml", buffer = bufnr })
			vim.keymap.set("n", "<leader>le", expand_macro, { desc = "expand macro", buffer = bufnr })

			utils.documentation.register("rust", external_docs)
			utils.hover.register(hover_actions, { desc = "rust-tools hover actions", buffer = bufnr, priority = 10 })
		end,
	})
end

return M
