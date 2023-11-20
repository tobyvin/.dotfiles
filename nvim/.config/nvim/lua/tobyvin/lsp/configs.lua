local ms = vim.lsp.protocol.Methods

local M = {
	bashls = {
		settings = {
			bashIde = {
				explainshellEndpoint = "https://explainshell.com",
				includeAllWorkspaceSymbols = true,
				shellcheckArguments = {
					string.format("--source-path=%s", vim.loop.cwd()),
				},
			},
		},
	},
	-- biome = {},
	clangd = {},
	cssls = {},
	cssmodules_ls = {},
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
	jsonls = {
		settings = {
			json = {
				format = {
					enable = true,
				},
				validate = {
					enable = true,
				},
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
		-- cmd = { "dotnet", "/home/tobyv/.local/share/nvim/mason/packages/omnisharp/OmniSharp.dll" },
		cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
		on_attach = function(client)
			-- HACK: https://github.com/OmniSharp/omnisharp-roslyn/issues/2483
			local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
			for i, v in ipairs(tokenModifiers) do
				tokenModifiers[i] = v:gsub(" ", "_"):gsub("-_", "")
			end

			local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
			for i, v in ipairs(tokenTypes) do
				tokenTypes[i] = v:gsub(" ", "_"):gsub("-_", "")
			end
		end,
	},
	perlnavigator = {
		settings = {
			perlnavigator = {
				enableWarnings = false,
			},
		},
	},
	powershell_es = {},
	pylsp = {},
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
	tsserver = {},
	yamlls = {
		settings = {
			yaml = {
				keyOrdering = false,
			},
		},
	},
}

return M
