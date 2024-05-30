local ms = vim.lsp.protocol.Methods

local M = {
	bashls = {
		filetypes = { "sh", "PKGBUILD" },
		settings = {
			bashIde = {
				explainshellEndpoint = "https://explainshell.com",
				includeAllWorkspaceSymbols = true,
				shellcheckArguments = {
					string.format("--source-path=%s", vim.uv.cwd()),
				},
			},
		},
		---@type fun(new_config: lspconfig.options.bashls, new_root_dir: any)
		on_new_config = function(new_config, new_root_dir)
			if vim.iter(vim.fs.dir(new_root_dir)):any(function(n)
				return n == "PKGBUILD"
			end) then
				new_config.settings.bashIde.shellcheckPath = "pkgbuildcheck"
			end
		end,
	},
	clangd = {},
	cssls = {
		handlers = {
			-- TODO: Find out why html ls is missing diagnostic handler without this.
			[ms.textDocument_diagnostic] = vim.lsp.diagnostic.on_diagnostic,
		},
	},
	denols = {},
	dockerls = {},
	gopls = {
		cmd = {
			"gopls",
			"serve",
		},
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
				},
				staticcheck = true,
			},
		},
	},
	html = {
		handlers = {
			-- TODO: Find out why html ls is missing diagnostic handler without this.
			[ms.textDocument_diagnostic] = vim.lsp.diagnostic.on_diagnostic,
		},
		filetypes = {
			"html",
			"htmldjango",
		},
	},
	-- jedi_language_server = {},
	jinja_lsp = {},
	lemminx = {
		settings = {
			xml = {
				catalogs = { "/etc/xml/catalog" },
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				workspace = {
					checkThirdParty = false,
				},
				completion = {
					callSnippet = "Replace",
				},
				format = {
					enable = false,
				},
			},
		},
	},
	ocamllsp = {},
	omnisharp = {
		cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
	},
	perlnavigator = {
		settings = {
			perlnavigator = {
				enableWarnings = false,
			},
		},
	},
	powershell_es = {},
	pylsp = {
		settings = {
			pylsp = {
				plugins = {
					black = { enabled = false },
					autopep8 = { enabled = false },
					yapf = { enabled = false },
					pycodestyle = {
						maxLineLength = 88,
					},
					pyflakes = { enabled = false },
					rope_autoimport = {
						enabled = true,
						code_actions = { enabled = true },
						completions = { enabled = false },
					},
				},
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
	ruff_lsp = {
		on_attach = function(client)
			if client.name == "ruff_lsp" then
				client.server_capabilities.hoverProvider = false
			end
		end,
	},
	taplo = {},
	texlab = {
		settings = {
			texlab = {
				build = {
					args = {
						"-interaction=nonstopmode",
						"-synctex=1",
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
				latexindent = {
					["local"] = string.format("%s/latexindent/indentconfig.yaml", vim.env.XDG_CONFIG_HOME),
					modifyLineBreaks = true,
				},
			},
		},
		on_attach = function(_, bufnr)
			vim.b[bufnr].tex_flavor = "latex"
			vim.wo[0][bufnr].spell = true
			vim.keymap.set("n", "gx", vim.cmd.TexlabForward, { desc = "open in pdf" })
		end,
	},
	typos_lsp = {
		filetypes = {
			"eml",
			"gitcommit",
			"mail",
			"markdown",
			"tex",
		},
	},
	-- check out [tinymist](https://github.com/Myriad-Dreamin/tinymist) as a possible alternative
	typst_lsp = {
		capabilities = {
			workspace = {
				didChangeConfiguration = {
					dynamicRegistration = true,
				},
			},
		},
		settings = {
			exportPdf = "onType",
		},
	},
	yamlls = {
		settings = {
			yaml = {
				keyOrdering = false,
			},
		},
	},
	zls = {},
}

return M
