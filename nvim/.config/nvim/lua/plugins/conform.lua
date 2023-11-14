---@type LazyPluginSpec
local M = {
	"stevearc/conform.nvim",
	version = "*",
	event = "BufReadPre",
	opts = {
		format_on_save = false,
		format_after_save = false,
		formatters_by_ft = {
			lua = { "stylua" },
			css = { "prettier" },
			django = { "djlint" },
			html = { "prettier" },
			htmldjango = { "djlint" },
			["jinja.html"] = { "djlint" },
			tex = { "latexindent" },
			plaintex = { "latexindent" },
			markdown = { "prettier", "markdownlint", "cbfmt" },
			python = { "black" },
			sass = { "prettier" },
			scss = { "prettier" },
			sh = { "shfmt" },
			PKGBUILD = { "shfmt" },
			["*"] = { "injected" },
		},
		formatters = {
			latexindent = {
				prepend_args = {
					"-l",
					("%s/latexindent/indentconfig.yaml"):format(vim.env.XDG_CONFIG_HOME),
				},
			},
			prettier = {
				prepend_args = { "--prose-wrap", "always" },
			},
			cbfmt = {
				command = "cbfmt",
				args = {
					"--stdin-filepath",
					"$FILENAME",
					"--best-effort",
					"--config",
					("%s/cbfmt/cbfmt.toml"):format(vim.env.XDG_CONFIG_HOME),
				},
				stdin = true,
			},
		},
	},
}

function M:init()
	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

return M
