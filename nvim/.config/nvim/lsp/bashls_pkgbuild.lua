return {
	cmd = { "bash-language-server", "start" },
	filetypes = { "PKGBUILD" },
	settings = {
		bashIde = {
			globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
			explainshellEndpoint = "https://explainshell.com",
			includeAllWorkspaceSymbols = true,
			bashIde = {
				shellcheckPath = "pkgbuildcheck",
			},
		},
	},
}
