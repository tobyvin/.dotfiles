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
				require("efmls-configs.formatters.prettier"),
			},
			django = {
				require("efmls-configs.linters.djlint"),
				require("efmls-configs.formatters.djlint"),
			},
			htmldjango = {
				require("efmls-configs.linters.djlint"),
				require("efmls-configs.formatters.djlint"),
			},
			javascript = {
				require("efmls-configs.formatters.prettier"),
			},
			["jinja.html"] = {
				require("efmls-configs.linters.djlint"),
				require("efmls-configs.formatters.djlint"),
			},
			lua = {
				require("efmls-configs.formatters.stylua"),
			},
			markdown = {
				require("efmls-configs.linters.markdownlint"),
				require("efmls-configs.formatters.prettier"),
				require("efmls-configs.formatters.cbfmt"),
			},
			python = {
				require("efmls-configs.formatters.black"),
			},
			sass = {
				require("efmls-configs.formatters.prettier"),
			},
			scss = {
				require("efmls-configs.formatters.prettier"),
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
