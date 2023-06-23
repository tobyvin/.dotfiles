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

	-- HACK: Workaround for null-ls unconditionally setting formatting capability
	-- See: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("null-ls", { clear = true }),
		desc = "set formatexpr based on null-ls source",
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)

			if
				client.name == "null-ls"
				and not require("null-ls.generators").can_run(
					vim.bo[args.buf].filetype,
					require("null-ls.methods").lsp.FORMATTING
				)
			then
				pcall(vim.keymap.del, "n", "gqq", { buffer = args.buf })
				pcall(vim.keymap.del, "n", "<leader>lf", { buffer = args.buf })
				vim.bo[args.buf].formatexpr = nil
			end
		end,
	})

	null_ls.setup({
		sources = {
			-- Disabled until sorting for code_actions gets pushed. See: https://github.com/stevearc/dressing.nvim/issues/22
			-- null_ls.builtins.code_actions.gitsigns,
			null_ls.builtins.code_actions.gitrebase,
			null_ls.builtins.code_actions.shellcheck.with({
				extra_filetypes = { "PKGBUILD" },
			}),
			null_ls.builtins.code_actions.typos,
			null_ls.builtins.diagnostics.markdownlint.with({
				extra_args = {
					("--config=%s/markdownlint/markdownlint.yaml"):format(vim.env.XDG_CONFIG_HOME),
				},
			}),
			null_ls.builtins.diagnostics.djlint,
			null_ls.builtins.diagnostics.typos,
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
		},
	})
end

return M
