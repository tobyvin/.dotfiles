---@type LazyPluginSpec
local M = {
	"stevearc/conform.nvim",
	version = "*",
	cmd = { "ConformInfo" },
	opts = {
		format_on_save = false,
		format_after_save = false,
		formatters_by_ft = {
			lua = { "stylua" },
			css = { "prettier" },
			html = { "prettier" },
			htmldjango = { "djlint" },
			tex = { "latexindent" },
			plaintex = { "latexindent" },
			markdown = { "prettier", "markdownlint" },
			nginx = { "nginxbeautifier" },
			python = { "black" },
			-- FIX: Remove if/when https://github.com/stevearc/conform.nvim/issues/127 gets fixed.
			rust = { "rustfmt" },
			sass = { "prettier" },
			scss = { "prettier" },
			sh = { "shfmt" },
			PKGBUILD = { "shfmt" },
			["*"] = { "injected", "trim_whitespace", "trim_newlines" },
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
			djlint = {
				prepend_args = function(ctx)
					return {
						"--indent=" .. vim.bo[ctx.buf].tabstop,
						"--profile=" .. (vim.bo[ctx.buf].filetype:gsub("htmldjango", "django")),
					}
				end,
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
