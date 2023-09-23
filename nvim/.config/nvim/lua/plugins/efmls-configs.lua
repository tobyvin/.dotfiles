---@type LazyPluginSpec
local M = {
	"creativenull/efmls-configs-nvim",
	version = "*",
	opts = {
		init_options = {
			documentFormatting = true,
			documentRangeFormatting = true,
		},
	},
}

function M:config(opts)
	opts.settings = vim.tbl_extend("force", opts.settings or {}, {
		languages = {
			css = {
				require("efmls-configs.formatters.stylelint"),
			},
			django = {
				require("efmls-configs.linters.djlint"),
				require("efmls-configs.formatters.djlint"),
			},
			htmldjango = {
				require("efmls-configs.linters.djlint"),
				require("efmls-configs.formatters.djlint"),
			},
			["jinja.html"] = {
				require("efmls-configs.linters.djlint"),
				require("efmls-configs.formatters.djlint"),
			},
			lua = {
				require("efmls-configs.formatters.stylua"),
			},
			markdown = {
				(function()
					local markdownlint = require("efmls-configs.linters.markdownlint")
					markdownlint.lintCommand = ("%s --config %s/markdownlint/markdownlint.yaml"):format(
						markdownlint.lintCommand,
						vim.env.XDG_CONFIG_HOME
					)
					return markdownlint
				end)(),
				(function()
					local cbfmt = require("efmls-configs.formatters.cbfmt")
					cbfmt.formatCommand = ("%s --config %s/cbfmt/cbfmt.toml"):format(
						cbfmt.formatCommand,
						vim.env.XDG_CONFIG_HOME
					)
					return cbfmt
				end)(),
				require("efmls-configs.formatters.mdformat"),
			},
			python = {
				require("efmls-configs.formatters.black"),
			},
			sass = {
				require("efmls-configs.formatters.stylelint"),
			},
			scss = {
				require("efmls-configs.formatters.stylelint"),
			},
			sh = {
				require("efmls-configs.formatters.shfmt"),
			},
		},
	})

	vim.list_extend(opts.filetypes or {}, vim.tbl_keys(opts.settings.languages))

	require("tobyvin.lsp.configs").efm = opts
end

return M
