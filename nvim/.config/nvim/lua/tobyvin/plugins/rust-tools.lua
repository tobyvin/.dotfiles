local M = {
	"simrat39/rust-tools.nvim",
	ft = "rust",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",
		"mfussenegger/nvim-dap",
	},
	opts = {
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
		group = vim.api.nvim_create_augroup("rust-tools", {}),
		desc = "setup rust-tools",
		callback = function(args)
			if vim.lsp.get_client_by_id(args.data.client_id).name ~= "rust_analyzer" then
				return
			end

			vim.keymap.set("n", "<leader>dd", require("rust-tools").debuggables.debuggables, {
				desc = "debug",
				buffer = args.buf,
			})
			vim.keymap.set("n", "<leader>tt", require("rust-tools").runnables.runnables, {
				desc = "test",
				buffer = args.buf,
			})
			vim.keymap.set("n", "<leader>le", require("rust-tools").expand_macro.expand_macro, {
				desc = "expand macro",
				buffer = args.buf,
			})
		end,
	})
end

return M
