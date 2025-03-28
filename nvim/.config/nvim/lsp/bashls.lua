---@brief
---
---https://github.com/bash-lsp/bash-language-server
--
-- `bash-language-server` can be installed via `npm`:
-- ```sh
-- npm i -g bash-language-server
-- ```
--
-- Language server for bash, written using tree sitter in typescript.
return {
	cmd = { "bash-language-server", "start" },
	filetypes = { "bash", "sh" },
	root_markers = { ".git" },
	settings = {
		bashIde = {
			-- Glob pattern for finding and parsing shell script files in the workspace.
			-- Used by the background analysis features across files.

			-- Prevent recursive scanning which will cause issues when opening a file
			-- directly in the home directory (e.g. ~/foo.sh).
			--
			-- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
			globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
			explainshellEndpoint = "https://explainshell.com",
			includeAllWorkspaceSymbols = true,
			shellcheckArguments = {
				string.format("--source-path=%s", vim.uv.cwd()),
			},
		},
	},
}
