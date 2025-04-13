vim.diagnostic.config({
	underline = true,
	virtual_text = {
		source = "if_many",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = " ",
		},
	},
	float = {
		scope = "cursor",
		source = true,
	},
	update_in_insert = true,
	severity_sort = true,
})
