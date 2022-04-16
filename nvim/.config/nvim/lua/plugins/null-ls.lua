	local status_ok, null_ls = pcall(require, "null-ls")
	if not status_ok then
		return
	end

	local code_actions = null_ls.builtins.code_actions
	local diagnostics = null_ls.builtins.diagnostics
	local formatting = null_ls.builtins.formatting

	null_ls.setup({
		sources = {

      require("null-ls").builtins.formatting.stylua,
			-- Code Actions
			code_actions.gitsigns,
			code_actions.shellcheck,

			-- Diagnostics
			-- diagnostics.codespell,
			-- diagnostics.luacheck,
			-- diagnostics.markdownlint,
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
