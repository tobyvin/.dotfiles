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
			code_actions.gitsigns,
			code_actions.shellcheck,

			-- Diagnostics
			diagnostics.markdownlint,
			-- diagnostics.luacheck,
			diagnostics.shellcheck,

			-- Formatting
			formatting.prettier,
			formatting.black,
			formatting.latexindent,
			formatting.markdownlint,
			formatting.stylua,
			formatting.shfmt,
		},
	})
end

return M
