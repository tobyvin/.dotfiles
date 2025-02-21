return vim.tbl_deep_extend("keep", {
	default_config = {
		settings = {
			bashIde = {
				shellcheckPath = "pkgbuildcheck",
			},
		},
		filetypes = { "PKGBUILD" },
	},
}, require("lspconfig/configs/bashls"))
