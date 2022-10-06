local lsp = require("tobyvin.lsp")
local M = {}

M.setup = function()
	local status_ok, null_ls = pcall(require, "null-ls")
	if not status_ok then
		vim.notify("Failed to load module 'null-ls'", vim.log.levels.ERROR)
		return
	end

	null_ls.setup({
		sources = {
			-- Disabled until sorting for code_actions gets pushed. See: https://github.com/stevearc/dressing.nvim/issues/22
			-- null_ls.builtins.code_actions.gitsigns,
			null_ls.builtins.code_actions.gitrebase,
			null_ls.builtins.code_actions.shellcheck,

			null_ls.builtins.diagnostics.markdownlint,

			null_ls.builtins.formatting.prettier.with({
				extra_args = { "--prose-wrap=always" },
			}),
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.shfmt,
			null_ls.builtins.formatting.cbfmt,
		},
		on_attach = function(client, bufnr)
			vim.keymap.set("n", "<leader>ln", "<CMD>NullLsInfo<CR>", { desc = "Null-LS Info", buffer = bufnr })
			lsp.on_attach(client, bufnr)
		end,
	})
end

return M
