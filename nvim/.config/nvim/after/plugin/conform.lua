local success, conform = pcall(require, "conform")
if not success then
	return
end

conform.setup({
	format_on_save = {},
	format_after_save = {},
	formatters_by_ft = {
		awk = { "gawk" },
		css = { "prettier" },
		graphql = { "prettier" },
		html = { "prettier", "injected" },
		htmldjango = { "prettier", "injected" },
		json = { "deno_fmt" },
		jsonc = { "deno_fmt" },
		lua = { "stylua" },
		markdown = { "mdformat", "injected" },
		nginx = { "nginxfmt" },
		plaintex = { "latexindent", "injected" },
		sh = { "shfmt" },
		sql = { "pg_format" },
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
	},
})

if pcall(require, "qmk") then
	local opts = {
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
	}

	local parse = require("qmk.parse")
	local format = require("qmk.format.qmk")
	conform.formatters.qmk_keymap = {
		format = function(_, _, lines, callback)
			local keymaps, config = parse.parse(table.concat(lines, "\n"), opts, parse.qmk)
			local formatted = format(keymaps, config)
			local out_lines = vim.list_slice(lines, 1, keymaps.pos.start + 1)
			vim.list_extend(out_lines, formatted)
			vim.list_extend(out_lines, lines, keymaps.pos.final + 1)
			callback(nil, out_lines)
		end,
	}

	local c_fmt = conform.formatters_by_ft.c or {}
	conform.formatters_by_ft.c = function(bufnr)
		if vim.api.nvim_buf_get_name(bufnr):match(".*keymap.c$") then
			return { "qmk_keymap", lsp_format = "first" }
		else
			return c_fmt --[[@as table]]
		end
	end
end

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
	vim.cmd.sleep("5m")
	return err
end

vim.o.formatexpr = "v:lua._G.formatexpr()"
