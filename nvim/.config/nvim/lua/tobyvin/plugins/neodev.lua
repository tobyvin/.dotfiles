local M = {}

M.setup = function()
	local status_ok, neodev = pcall(require, "neodev")
	if not status_ok then
		vim.notify("Failed to load module 'neodev'", vim.log.levels.ERROR)
		return
	end

	neodev.setup({
		library = {
			enabled = true,
			runtime = true,
			types = true,
			plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
		},
		override = function(root_dir, library)
			local lua_dev_utils = require("lua-dev.util")
			if lua_dev_utils.has_file(root_dir, lua_dev_utils.fqn("~/.dotfiles/nvim/.config/nvim")) then
				library.enabled = true
				library.runtime = true
				library.types = true
				library.plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" }
			end
		end,
	})

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
