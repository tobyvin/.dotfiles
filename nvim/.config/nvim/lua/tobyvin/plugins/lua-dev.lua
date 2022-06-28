local M = {}

M.setup = function()
	local status_ok, lua_dev = pcall(require, "lua-dev")
	if not status_ok then
		vim.notify("Failed to load module 'lua-dev'", "error")
		return
	end

	local lsp = require("tobyvin.lsp")
	local lspconfig = require("lspconfig")

	lspconfig.sumneko_lua.setup(lua_dev.setup({
		runtime_path = true,
		lspconfig = lsp.config({
			settings = {
				Lua = {
					format = {
						enable = false,
					},
					telemetry = {
						enable = false,
					},
				},
			},
		}),
	}))
end

return M
