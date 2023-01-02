local M = {
	bashls = {},
	taplo = {},
	yamlls = {},
	tsserver = {},
	cssls = {},
	cssmodules_ls = {},
	stylelint_lsp = {},
	clangd = {},
	pylsp = {},
}

M.jsonls = {
	settings = {
		json = {
			format = {
				enable = true,
			},
			validate = { enable = true },
		},
	},
}

M.gopls = {
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

M.rust_analyzer = {
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

M.sumneko_lua = {
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
	on_attach = function(_, bufnr)
		require("tobyvin.utils.documentation").register(function()
			local word = vim.fn.expand("<cword>")
			if word then
				local ret = pcall(vim.cmd.help, word)
				return not ret
			end
		end, { desc = "help", priority = 10, buffer = bufnr })
	end,
}

M.texlab = {
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

return M
