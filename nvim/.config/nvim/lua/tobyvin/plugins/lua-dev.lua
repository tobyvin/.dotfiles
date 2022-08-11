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
		library = {
			vimruntime = true, -- runtime path
			types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
			plugins = true, -- installed opt or start plugins in packpath
			-- you can also specify the list of plugins to make available as a workspace library
			-- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
		},
		-- runtime_path = true,
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
