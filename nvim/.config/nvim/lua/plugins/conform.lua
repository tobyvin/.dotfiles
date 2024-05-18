---@type LazyPluginSpec
local M = {
	"stevearc/conform.nvim",
	version = "*",
	cmd = { "ConformInfo" },
	opts = {
		format_on_save = false,
		format_after_save = false,
		formatters_by_ft = {
			css = { "prettier" },
			html = { "prettier" },
			htmldjango = { "djlint" },
			json = { "deno_fmt" },
			jsonc = { "deno_fmt" },
			lua = { "stylua" },
			markdown = { "mdformat", "markdownlint" },
			nginx = { "nginxfmt" },
			plaintex = { "latexindent" },
			sass = { "prettier" },
			scss = { "prettier" },
			sh = { "shfmt" },
			tex = { "latexindent" },
			typst = { "typstyle" },
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
				prepend_args = function(_, ctx)
					return {
						"--indent=" .. vim.bo[ctx.buf].tabstop,
						"--profile=" .. (vim.bo[ctx.buf].filetype:gsub("htmldjango", "django")),
					}
				end,
			},
			nginxfmt = {
				command = "nginxfmt.py",
				args = function(_, ctx)
					return {
						"-i",
						vim.bo[ctx.buf].tabstop,
						"-",
					}
				end,
				stdin = true,
			},
			nginxbeautifier = {
				command = "nginxbeautifier",
				args = function(_, ctx)
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
			typstyle = {
				meta = {
					url = "https://github.com/Enter-tainer/typstyle",
					description = "Beautiful and reliable typst code formatter",
				},
				command = "typstyle",
				stdin = true,
			},
		},
	},
}

function M:init()
	U.formatexpr = function(...)
		if not pcall(require, "fidget.progress") then
			return require("conform").formatexpr(...)
		end

		local bufnr = vim.api.nvim_get_current_buf()
		local handle = require("fidget.progress").handle.create({
			title = "Formatting",
			message = string.format("buffer: %s", bufnr),
			lsp_client = { name = "conform" },
		})

		local err = require("conform").formatexpr()
		if err == 1 then
			handle.message = "Failed"
		else
			handle.message = "Completed"
		end

		handle:finish()
		return err
	end

	vim.o.formatexpr = "v:lua.U.formatexpr()"
end

return M
