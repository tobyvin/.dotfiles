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
	perlnavigator = {
		settings = {
			perlnavigator = {
				enableWarnings = false,
			},
		},
	},
	jsonls = {
		settings = {
			json = {
				format = {
					enable = true,
				},
				validate = { enable = true },
			},
		},
	},
	gopls = {
		cmd = { "gopls", "serve" },
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
				},
				staticcheck = true,
			},
		},
	},
	rust_analyzer = {
		standalone = true,
		settings = {
			["rust-analyzer"] = {
				cargo = {
					features = "all",
					buildScripts = {
						enable = true,
					},
				},
				check = {
					command = "clippy",
				},
				completion = {
					postfix = {
						enable = false,
					},
				},
				imports = {
					granularity = {
						enforce = true,
					},
				},
				procMacro = {
					enable = true,
					ignored = {
						["tracing-attributes"] = {
							"instrument",
						},
					},
				},
			},
		},
	},
	sumneko_lua = {
		settings = {
			Lua = {
				workspace = {
					checkThirdParty = false,
				},
				completion = {
					callSnippet = "Replace",
				},
				diagnostics = {
					globals = { "vim" },
				},
				format = {
					enable = false,
				},
			},
		},
	},
	texlab = {
		settings = {
			texlab = {
				rootDirectory = ".",
				build = {
					args = {
						"-pdf",
						"-interaction=nonstopmode",
						"-synctex=1",
						"-auxdir=../build",
						"-outdir=../build",
						"-emulate-aux-dir",
						"%f",
					},
					onSave = true,
				},
				forwardSearch = {
					executable = "zathura",
					args = {
						"--synctex-editor-command",
						[[nvim-texlabconfig -file '%{input}' -line %{line}]],
						"--synctex-forward",
						"%l:1:%f",
						"%p",
					},
				},
				chktex = {
					onEdit = true,
					onOpenAndSave = true,
				},
				auxDirectory = "../build",
				latexindent = {
					["local"] = string.format("%s/latexindent/indentconfig.yaml", vim.env.XDG_CONFIG_HOME),
					modifyLineBreaks = true,
				},
			},
		},
		on_attach = function(_, bufnr)
			vim.b[bufnr].tex_flavor = "latex"
			vim.wo.spell = true

			local preview_autocmd
			local augroup = vim.api.nvim_create_augroup("texlab", {})

			vim.api.nvim_create_user_command("TexlabPreview", function()
				preview_autocmd = vim.api.nvim_create_autocmd("CursorMoved", {
					group = augroup,
					command = "TexlabForward",
				})

				vim.cmd.TexlabForward()
			end, { desc = "Texlab preview start" })

			vim.api.nvim_create_user_command("TexlabPreviewStop", function()
				if preview_autocmd then
					vim.api.nvim_del_autocmd(preview_autocmd)
				end
			end, { desc = "Texlab preview stop" })
		end,
	},
}

return M
