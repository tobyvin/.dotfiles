---@type LazySpec
local M = {
	"mfussenegger/nvim-lint",
	opts = {
		markdown = { "markdownlint" },
		htmldjango = { "djlint" },
	},
}

function M:init()
	local augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })

	vim.api.nvim_create_autocmd({ "BufReadPost", "TextChanged", "InsertLeave" }, {
		group = augroup,
		callback = function()
			require("lint").try_lint({ "typos" })
		end,
	})

	vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
		group = augroup,
		callback = function()
			require("lint").try_lint()
		end,
	})
end

local in_spell_node = function(bufnr, row, col)
	local captures = vim.treesitter.get_captures_at_pos(bufnr, row, col)
	local spell_node = false

	for _, capture in pairs(captures) do
		if capture.capture == "nospell" then
			return false
		end

		spell_node = spell_node or capture.capture == "spell"
	end
	return spell_node
end

function M:config(opts)
	require("lint").linters.djlint = {
		cmd = "djlint",
		args = { "--quiet", "--profile=django", "-" },
		stdin = true,
		stream = "stdout",
		ignore_exitcode = true,
		parser = require("lint.parser").from_pattern(
			"(%w+) (%d+):(%d+) (.*)",
			{ "code", "lnum", "col", "message" },
			{ source = "djlint" },
			{ end_col_offset = 1 }
		),
	}

	require("lint").linters.typos = {
		cmd = "typos",
		args = { "--format", "json", "-" },
		stdin = true,
		stream = "stdout",
		ignore_exitcode = true,
		parser = function(output, bufnr)
			local diagnostics = {}

			for line in vim.gsplit(output, "\n", { trimempty = true }) do
				local ok, data = pcall(vim.json.decode, line)
				if ok and data ~= nil and in_spell_node(bufnr, data.line_num - 1, data.byte_offset) then
					table.insert(diagnostics, {
						bufnr = bufnr,
						lnum = data.line_num - 1,
						col = data.byte_offset,
						end_col = data.byte_offset + data.typo:len(),
						severity = vim.diagnostic.severity.ERROR,
						message = ("`%s` -> `%s`"):format(data.typo, table.concat(data.corrections, "`, `")),
						source = "typos",
						user_data = { corrections = data.corrections },
					})
				end
			end

			return diagnostics
		end,
	}

	require("lint").linters_by_ft = opts
end

return M
