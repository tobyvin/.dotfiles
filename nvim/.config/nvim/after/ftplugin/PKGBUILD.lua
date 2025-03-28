vim.cmd.runtime({ "after/ftplugin/sh.{vim,lua}", bang = true })

if not vim.lsp.config.bashls_pkgbuild then
	vim.lsp.config(
		"bashls_pkgbuild",
		vim.tbl_extend("force", vim.lsp.config.bashls, {
			filetypes = { "PKGBUILD" },
			settings = { bashIde = { shellcheckPath = "pkgbuildcheck" } },
		})
	)
	vim.lsp.enable("bashls_pkgbuild")
end
