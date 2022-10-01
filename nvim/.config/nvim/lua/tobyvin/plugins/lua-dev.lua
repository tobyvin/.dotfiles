local M = {}

M.setup = function()
	local status_ok, lua_dev = pcall(require, "lua-dev")
	if not status_ok then
		vim.notify("Failed to load module 'lua-dev'", vim.log.levels.ERROR)
		return
	end

	lua_dev.setup()

	local lsp = require("tobyvin.lsp")
	local lspconfig = require("lspconfig")

	lspconfig.sumneko_lua.setup(lsp.config({
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
				diagnostics = {
					globals = { "vim", "packer_plugins" },
				},
				format = {
					enable = false,
				},
				telemetry = {
					enable = false,
				},
			},
		},
	}))
end

return M
