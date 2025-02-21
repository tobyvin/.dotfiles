---@module "lspconfig"

local ms = vim.lsp.protocol.Methods

local data_path = vim.fn.stdpath("data") --[[@as string]]

---@type lspconfig.Config.command
local angular_cmd = {
	"ngserver",
	"--stdio",
	"--tsProbeLocations",
	table.concat({
		vim.fs.joinpath(data_path, "mason", "packages", "angular-language-server"),
		vim.uv.cwd(),
	}, ","),
	"--ngProbeLocations",
	table.concat({
		vim.fs.joinpath(
			data_path,
			"mason",
			"packages",
			"angular-language-server",
			"node_modules",
			"@angular",
			"language-server"
		),
		vim.uv.cwd(),
	}, ","),
}

---@class LspConfig: lspconfig.Config
---@field cmd lspconfig.Config.command?

---@type table<string, LspConfig>
local M = {
	angularls = {
		cmd = angular_cmd,
		on_new_config = function(new_config, _)
			new_config.cmd = angular_cmd
		end,
	},
	bashls = {
		settings = {
			bashIde = {
				explainshellEndpoint = "https://explainshell.com",
				includeAllWorkspaceSymbols = true,
				shellcheckArguments = {
					string.format("--source-path=%s", vim.uv.cwd()),
				},
			},
		},
	},
	bashls_pkgbuild = {
		settings = {
			bashIde = {
				explainshellEndpoint = "https://explainshell.com",
				includeAllWorkspaceSymbols = true,
				shellcheckArguments = {
					string.format("--source-path=%s", vim.uv.cwd()),
				},
			},
		},
	},
	clangd = {},
	cssls = {
		handlers = {
			-- TODO: Find out why html ls is missing diagnostic handler without this.
			[ms.textDocument_diagnostic] = vim.lsp.diagnostic.on_diagnostic,
		},
	},
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
	mesonlsp = {},
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
	pyright = {
		settings = {
			pyright = {
				disableOrganizeImports = true,
			},
			python = {
				analysis = {
					ignore = { "*" },
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
		on_attach = function(client, bufnr)
			local function external_docs()
				local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
				local resp, err = client.request_sync("experimental/externalDocs", params, nil, bufnr)

				if resp == nil then
					if err then
						vim.notify(
							string.format("External docs request failed: %s", err),
							vim.log.levels.ERROR,
							{ title = client.name }
						)
					else
						vim.notify("No external docs found", vim.log.levels.WARN, { title = client.name })
					end
					return "gx"
				else
					if resp.err then
						vim.notify(
							string.format(
								"%s error: [%s] %s",
								client.name,
								resp.err.code or "unknown code",
								resp.err.data or "(no description)"
							),
							vim.log.levels.ERROR,
							{ title = client.name }
						)
					elseif resp.result then
						local url = resp.result["local"] or resp.result.web or resp.result
						url = string.gsub(url, "/macros/macro%.", "/macro%.")
						vim.ui.open(url)
					end
					return "<Ignore>"
				end
			end

			vim.keymap.set({ "x", "n" }, "gx", external_docs, {
				expr = true,
				desc = "open external docs",
				buffer = bufnr,
			})
		end,
	},
	ruff = {
		server_capabilities = {
			hoverProvider = false,
		},
	},
	taplo = {},
	texlab = {
		settings = {
			texlab = {
				build = {
					forwardSearchAfter = true,
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
						[[nvim-texlabconfig -file '%%%{input}' -line %%%{line} -server ]] .. vim.v.servername,
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
					["local"] = vim.fs.joinpath(vim.env.XDG_CONFIG_HOME, "latexindent/indentconfig.yaml"),
					modifyLineBreaks = true,
				},
			},
		},
		on_attach = function(_, bufnr)
			vim.b[bufnr].tex_flavor = "latex"
			vim.wo[0][bufnr].spell = true
		end,
	},
	ts_ls = {
		settings = {
			javascript = {
				inlayHints = {
					includeInlayEnumMemberValueHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
					includeInlayParameterNameHintsWhenArgumentMatchesName = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayVariableTypeHints = false,
				},
			},
			typescript = {
				inlayHints = {
					includeInlayEnumMemberValueHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
					includeInlayParameterNameHintsWhenArgumentMatchesName = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayVariableTypeHints = false,
				},
			},
		},
	},
	typos_lsp = {
		filetypes = {
			"eml",
			"gitcommit",
			"mail",
			"markdown",
			"tex",
		},
		init_options = {
			config = vim.fs.joinpath(vim.env.XDG_CONFIG_HOME, "typos.toml"),
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
		server_capabilities = {
			documentFormattingProvider = true,
		},
	},
	zls = {},
}

return M
