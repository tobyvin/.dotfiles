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
	jinja_lsp = {},
	lemminx = {
		settings = {
			xml = {
				catalogs = { "/etc/xml/catalog" },
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
