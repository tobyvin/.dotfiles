---@type LazySpec
local M = {
	"stevearc/conform.nvim",
	cmd = { "ConformInfo" },
	dependencies = {
		{
			"codethread/qmk.nvim",
			opts = {
				name = "LAYOUT_5x6",
				auto_format_pattern = nil,
				comment_preview = {
					position = "none",
				},
				layout = {
					"x x x x x x _ x x x x x x",
					"x x x x x x _ x x x x x x",
					"x x x x x x _ x x x x x x",
					"x x x x x x _ x x x x x x",
					"_ _ x x _ _ _ _ _ x x _ _",
					"_ _ _ _ x x _ x x _ _ _ _",
					"_ _ _ _ x x _ x x _ _ _ _",
					"_ _ _ _ x x _ x x _ _ _ _",
				},
			},
			config = function(_, opts)
				local config = require("qmk.config")
				local utils = require("qmk.utils")

				local ok, config_or_error = pcall(config.parse, opts)
				if not ok then
					utils.notify(config_or_error)
					return
				end
				require("qmk").options = config_or_error
			end,
		},
	},
	opts = {
		format_on_save = false,
		format_after_save = false,
		formatters_by_ft = {
			awk = { "gawk" },
			c = function(bufnr)
				if vim.api.nvim_buf_get_name(bufnr):match(".*keymap.c$") then
					return { "qmk_keymap", lsp_format = "first" }
				else
					return {}
				end
			end,
			css = { "css_beautify" },
			graphql = { "prettier" },
			html = { "html_beautify", "injected" },
			htmldjango = { "html_beautify", "injected" },
			json = { "deno_fmt" },
			jsonc = { "deno_fmt" },
			lua = { "stylua" },
			markdown = { "mdformat", "injected" },
			nginx = { "nginxfmt" },
			plaintex = { "latexindent", "injected" },
			sh = { "shfmt" },
			tex = { "latexindent", "injected" },
			typst = { "typstyle", "injected" },
		},
		formatters = {
			latexindent = {
				prepend_args = {
					"-g",
					"/dev/null",
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
				prepend_args = function(_, ctx)
					return {
						"-i",
						vim.bo[ctx.buf].tabstop,
						"-",
					}
				end,
			},
			typstyle = {
				meta = {
					url = "https://github.com/Enter-tainer/typstyle",
					description = "Beautiful and reliable typst code formatter",
				},
				command = "typstyle",
				stdin = true,
			},
			qmk_keymap = {
				format = function(_, _, lines, callback)
					local options = require("qmk").options
					local parse = require("qmk.parse")
					local format = require("qmk.format.qmk")

					local keymaps, config = parse.parse(table.concat(lines, "\n"), options, parse.qmk)
					local formatted = format(keymaps, config)
					local out_lines = vim.list_slice(lines, 1, keymaps.pos.start + 1)
					vim.list_extend(out_lines, formatted)
					vim.list_extend(out_lines, lines, keymaps.pos.final + 1)
					callback(nil, out_lines)
				end,
			},
		},
	},
}

function M:init()
	_G.formatexpr = function(...)
		local bufnr = vim.api.nvim_get_current_buf()
		local handle = require("fidget.progress").handle.create({
			title = "Formatting",
			message = string.format("buffer: %s", bufnr),
			lsp_client = { name = "conform" },
		})

		local err = require("conform").formatexpr(...)
		if err == 1 then
			handle.message = "Failed"
		else
			handle.message = "Completed"
		end

		handle:finish()

		-- HACK: fixes text flashing/rerendering on buffers without a formatter
		vim.cmd.sleep("1m")
		return err
	end

	vim.o.formatexpr = "v:lua._G.formatexpr()"
end

return M
