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

return require("null-ls.helpers").make_builtin({
	name = "typos",
	meta = {
		url = "https://github.com/crate-ci/typos",
		description = "Source code spell checker written in Rust.",
	},
	method = require("null-ls.methods").internal.DIAGNOSTICS,
	filetypes = {},
	generator_opts = {
		command = "typos",
		args = {
			"--format",
			"json",
			"-",
		},
		to_stdin = true,
		format = "line",
		check_exit_code = function(code)
			return code == 2
		end,
		on_output = function(line, params)
			local ok, data = pcall(vim.json.decode, line)
			if not ok or data == nil then
				return
			end

			if in_spell_node(params.bufnr, data.line_num - 1, data.byte_offset) then
				return {
					row = data.line_num,
					col = data.byte_offset + 1,
					end_col = data.byte_offset + 1 + data.typo:len(),
					message = ("`%s` should be `%s`"):format(data.typo, table.concat(data.corrections, "`, `")),
					severity = require("null-ls.helpers").diagnostics.severities.error,
					user_data = { corrections = data.corrections },
				}
			end
		end,
	},
	factory = require("null-ls.helpers").generator_factory,
})
