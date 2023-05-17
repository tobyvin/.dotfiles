local typos_diagnostics = function(bufnr, lnum, cursor_col)
	local diagnostics = {}
	for _, diagnostic in ipairs(vim.diagnostic.get(bufnr, { lnum = lnum })) do
		if diagnostic.source == "typos" and cursor_col >= diagnostic.col and cursor_col < diagnostic.end_col then
			table.insert(diagnostics, diagnostic)
		end
	end
	return diagnostics
end

return require("null-ls.helpers").make_builtin({
	name = "typos",
	meta = {
		url = "https://github.com/crate-ci/typos",
		description = "Source code spell checker written in Rust.",
	},
	method = require("null-ls.methods").internal.CODE_ACTION,
	filetypes = {},
	generator = {
		fn = function(params)
			local actions = {}
			local diagnostics = typos_diagnostics(params.bufnr, params.row - 1, params.col)
			if vim.tbl_isempty(diagnostics) then
				return nil
			end
			for _, diagnostic in ipairs(diagnostics) do
				for _, correction in ipairs(diagnostic.user_data.corrections) do
					table.insert(actions, {
						title = string.format("Use `%s`", correction),
						action = function()
							vim.api.nvim_buf_set_text(
								diagnostic.bufnr,
								diagnostic.lnum,
								diagnostic.col,
								diagnostic.end_lnum,
								diagnostic.end_col,
								{ correction }
							)
						end,
					})
				end
			end
			return actions
		end,
	},
})
