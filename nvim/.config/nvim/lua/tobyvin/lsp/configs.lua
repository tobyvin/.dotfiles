local configs = {
	bashls = {},
	taplo = {},
	yamlls = {},
	tsserver = {},
	cssls = {},
	cssmodules_ls = {},
	stylelint_lsp = {},
  clangd = {},
}

configs.gopls = {
	cmd = { "gopls", "serve" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
}

configs.rust_analyzer = {
	standalone = true,
	settings = {
		["rust-analyzer"] = {
			cargo = {
				features = "all",
			},
			checkOnSave = {
				command = "clippy",
			},
			completion = {
				postfix = {
					enable = false,
				},
			},
		},
	},
}

configs.sumneko_lua = {
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
}

configs.texlab = {
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
	on_attach = function(_, bufnr)
		vim.b[bufnr].tex_flavor = "latex"
		vim.wo.spell = true
	end,
}

return configs
