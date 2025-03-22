return {
	cmd = { "bash-language-server", "start" },
	filetypes = { "bash", "sh" },
	settings = {
		bashIde = {
			globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
			explainshellEndpoint = "https://explainshell.com",
			includeAllWorkspaceSymbols = true,
			shellcheckArguments = {
				string.format("--source-path=%s", vim.uv.cwd()),
			},
		},
	},
}
