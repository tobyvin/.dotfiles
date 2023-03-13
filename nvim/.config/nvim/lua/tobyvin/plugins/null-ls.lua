local M = {
	"jose-elias-alvarez/null-ls.nvim",
	event = "BufReadPre",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}

function M.config()
	local null_ls = require("null-ls")

	local info = require("null-ls.info")

	null_ls.setup({
		sources = {
			-- Disabled until sorting for code_actions gets pushed. See: https://github.com/stevearc/dressing.nvim/issues/22
			-- null_ls.builtins.code_actions.gitsigns,
			null_ls.builtins.code_actions.gitrebase,
			null_ls.builtins.code_actions.shellcheck,
			null_ls.builtins.diagnostics.markdownlint,
			null_ls.builtins.formatting.prettier.with({
				disabled_filetypes = { "json", "jsonc" },
				extra_args = { "--prose-wrap=always" },
			}),
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.shfmt,
			null_ls.builtins.formatting.cbfmt,
			null_ls.builtins.formatting.nginx_beautifier,
		},
		on_attach = function(_, bufnr)
			vim.keymap.set("n", "<leader>ln", info.show_window, { desc = "null-ls info", buffer = bufnr })
		end,
	})
end

return M
