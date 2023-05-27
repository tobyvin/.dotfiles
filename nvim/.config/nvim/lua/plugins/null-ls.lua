local M = {
	"jose-elias-alvarez/null-ls.nvim",
	event = "BufReadPre",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"LostNeophyte/null-ls-embedded",
			config = function()
				require("null-ls").register(require("null-ls-embedded").nls_source)
			end,
		},
	},
}

function M.config()
	local null_ls = require("null-ls")

	null_ls.setup({
		sources = {
			-- Disabled until sorting for code_actions gets pushed. See: https://github.com/stevearc/dressing.nvim/issues/22
			-- null_ls.builtins.code_actions.gitsigns,
			null_ls.builtins.code_actions.gitrebase,
			null_ls.builtins.code_actions.shellcheck.with({
				extra_filetypes = { "PKGBUILD" },
			}),
			null_ls.builtins.code_actions.typos,
			null_ls.builtins.formatting.prettier.with({
				disabled_filetypes = { "json", "jsonc" },
				extra_args = { "--prose-wrap=always" },
			}),
			null_ls.builtins.formatting.djlint.with({
				extra_args = { "--indent=2" },
			}),
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.shfmt.with({
				extra_filetypes = { "PKGBUILD" },
			}),
			null_ls.builtins.formatting.nginx_beautifier,
		},
	})
end

return M
