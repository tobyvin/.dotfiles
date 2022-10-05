local lsp = require("tobyvin.lsp")
local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	local status_ok, lspconfig = pcall(require, "lspconfig")
	if not status_ok then
		vim.notify("Failed to load module 'lspconfig'", vim.log.levels.ERROR)
		return
	end

	lspconfig.bashls.setup(lsp.config())

	lspconfig.taplo.setup(lsp.config())

	lspconfig.yamlls.setup(lsp.config({
		settings = {
			yaml = {
				editor = {
					formatOnType = true,
				},
				format = {
					enable = true,
				},
			},
			redhat = {
				telemetry = {
					enabled = false,
				},
			},
		},
	}))

	lspconfig.tsserver.setup(lsp.config())

	lspconfig.pylsp.setup(lsp.config({
		settings = {
			pylsp = {
				plugins = {
					autopep8 = {
						enabled = false,
					},
					yapf = {
						enabled = false,
					},
					pylint = {
						enabled = true,
					},
				},
			},
		},
	}))

	lspconfig.cssls.setup(lsp.config())

	lspconfig.cssmodules_ls.setup(lsp.config())

	lspconfig.stylelint_lsp.setup(lsp.config())

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

	lspconfig.texlab.setup(lsp.config({
		settings = {
			texlab = {
				build = {
					args = {
						"-pdf",
						"-interaction=nonstopmode",
						"-synctex=1",
						string.format("-auxdir=%s/aux", vim.fn.getcwd()),
						string.format("-outdir=%s/out", vim.fn.getcwd()),
						"-emulate-aux-dir",
						"%f",
					},
					onSave = true,
				},
				chktex = {
					onEdit = true,
					onOpenAndSave = true,
				},
				auxDirectory = string.format("%s/aux", vim.fn.getcwd()),
				latexindent = {
					["local"] = string.format("%s/latexindent/indentconfig.yaml", vim.env.XDG_CONFIG_HOME),
					modifyLineBreaks = true,
				},
			},
		},
		on_attach = function(client, bufnr)
			vim.g.tex_flavor = "latex"
			vim.opt.spell = true
			lsp.on_attach(client, bufnr)
		end,
	}))

	require("lsp_signature").setup({
		bind = true,
		handler_opts = {
			border = "rounded",
		},
	})
end

return M
