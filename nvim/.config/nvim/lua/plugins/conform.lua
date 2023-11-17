---@type LazyPluginSpec
local M = {
	"stevearc/conform.nvim",
	version = "*",
	cmd = { "ConformInfo" },
	opts = {
		format_on_save = false,
		format_after_save = false,
		log_level = vim.log.levels.DEBUG,
		formatters_by_ft = {
			lua = { "stylua" },
			css = { "prettier" },
			django = { "djlint" },
			html = { "prettier" },
			htmldjango = { "djlint" },
			["jinja.html"] = { "djlint" },
			tex = { "latexindent" },
			plaintex = { "latexindent" },
			-- FIX: Move "injected" back to "*" if/when https://github.com/stevearc/conform.nvim/issues/200 is fixed.
			markdown = { "prettier", "markdownlint", "injected" },
			nginx = { "nginxbeautifier" },
			python = { "black" },
			-- FIX: Remove if/when https://github.com/stevearc/conform.nvim/issues/127 gets fixed.
			rust = { "rustfmt" },
			sass = { "prettier" },
			scss = { "prettier" },
			sh = { "shfmt" },
			PKGBUILD = { "shfmt" },
			-- ["*"] = { "injected" },
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
			nginxbeautifier = {
				command = "nginxbeautifier",
				args = function(ctx)
					return {
						vim.bo[ctx.buf].expandtab and "-s" or "-t",
						vim.bo[ctx.buf].tabstop,
						"-i",
						"$FILENAME",
						"-o",
						"$FILENAME",
					}
				end,
				stdin = false,
			},
		},
	},
}

function M:init()
	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

return M
