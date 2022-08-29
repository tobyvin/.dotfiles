local lsp = require("tobyvin.lsp")
local M = {}

M.setup = function()
	local status_ok, null_ls = pcall(require, "null-ls")
	if not status_ok then
		vim.notify("Failed to load module 'null-ls'", "error")
		return
	end

	local code_actions = null_ls.builtins.code_actions
	local diagnostics = null_ls.builtins.diagnostics
	local formatting = null_ls.builtins.formatting

	null_ls.setup({
		sources = {

			-- Code Actions
			code_actions.gitrebase,
			-- Disabled until sorting for code_actions gets pushed. See: https://github.com/stevearc/dressing.nvim/issues/22
			-- code_actions.gitsigns,
			code_actions.shellcheck,

			-- Diagnostics
			diagnostics.checkmake,

			-- Formatting
			formatting.prettier,
			formatting.black,
			formatting.latexindent,
			formatting.markdownlint,
			formatting.stylua,
			formatting.shfmt,
		},
		on_attach = lsp.on_attach,
		-- on_attach = function(client, bufnr)
		-- 	client.server_capabilities.documentFormattingProvider = client.supports_method("textDocument/formatting")
		-- 	lsp.on_attach(client, bufnr)
		-- end,
	})
end

return M
