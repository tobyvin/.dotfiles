local lsp = require("tobyvin.lsp")
local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	require("nvim-lsp-installer").setup({})

	local status_ok, lspconfig = pcall(require, "lspconfig")
	if not status_ok then
		vim.notify("Failed to load module 'lspconfig'", "error")
		return
	end

	lspconfig.tsserver.setup(lsp.config())

	lspconfig.ccls.setup(lsp.config())

	lspconfig.gopls.setup(lsp.config({
		cmd = { "gopls", "serve" },
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
				},
				staticcheck = true,
			},
		},
	}))

	lspconfig.ltex.setup(lsp.config())

	lspconfig.texlab.setup(lsp.config({
		init_options = { documentFormatting = true },
		settings = {
			texlab = {
				build = {
					args = {"-pdf", "-interaction=nonstopmode", "-synctex=1", "-auxdir=../aux", "-outdir=../", "-emulate-aux-dir", "%f"},
					onSave = true,
				},
				chktex = {
					onEdit = true,
					onOpenAndSave = true,
				},
				latexindent = {
					modifyLineBreaks = true,
				},
				auxDirectory = "../aux",
			},
		},
		on_attach = function(client, bufnr)
			vim.g.tex_flavor = "latex"
			lsp.on_attach(client, bufnr)
		end,
	}))

	require("lsp_signature").setup({
		bind = true,
		handler_opts = {
			border = "rounded",
		},
	})

	local nmap = utils.create_map_group("n", "<leader>l", "LSP")
	nmap("<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP info" })
	nmap("<leader>lI", "<cmd>LspInstallInfo<cr>", { desc = "LSP installer info" })
end

return M
