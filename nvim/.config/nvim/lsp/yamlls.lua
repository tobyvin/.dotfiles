---@type vim.lsp.Config
return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
	settings = {
		redhat = {
			telemetry = {
				enabled = false,
			},
		},
		yaml = {
			keyOrdering = false,
		},
	},
	server_capabilities = {
		documentFormattingProvider = true,
	},
}
