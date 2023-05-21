---@type LazySpec
local M = {
	"williamboman/mason-lspconfig.nvim",
	version = "*",
	event = "BufReadPre",
	cmd = {
		"LspInstall",
		"LspUninstall",
	},
	dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
	opts = {
		handlers = {
			function(name)
				local config = require("tobyvin.lsp.configs")[name] or {}
				local available = require("lspconfig").util.available_servers()

				if not vim.tbl_contains(available, name) then
					require("lspconfig")[name].setup(config)
				end
			end,
		},
	},
}

function M:init()
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("mason-lspconfig", { clear = true }),
		callback = function(args)
			if vim.bo[args.buf].buftype ~= "" then
				return
			end

			local available = require("mason-lspconfig").get_available_servers({ filetype = args.match })
			if #available == 0 then
				return
			end

			local installed = require("mason-lspconfig").get_installed_servers()
			for _, server in ipairs(available) do
				if vim.tbl_contains(installed, server) then
					return
				end
			end

			vim.schedule(vim.cmd.LspInstall)
		end,
		desc = "prompt to install missing lspconfig servers",
	})
end

return M
