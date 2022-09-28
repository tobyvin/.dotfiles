local M = {}

M.signs = {
	hint = { text = " ", texthl = "DiagnosticSignHint" },
	info = { text = " ", texthl = "DiagnosticSignInfo" },
	warn = { text = " ", texthl = "DiagnosticSignWarn" },
	error = { text = " ", texthl = "DiagnosticSignError" },
}

setmetatable(M.signs, {
	__index = function(t, k)
		if type(k) == "number" then
			return t[vim.diagnostic.severity[k]]
		end
		return t[k:lower():gsub("warning", "warn")]
	end,
})

M.count = function(bufnr)
	local items = {}
	for i, level in ipairs(vim.diagnostic.severity) do
		items[level] = #vim.diagnostic.get(bufnr, { severity = i })
	end

	setmetatable(items, {
		__index = function(t, k)
			if type(k) == "number" then
				return t[vim.diagnostic.severity[k]]
			end
			return t[k:upper():gsub("WARNING", "WARN")]
		end,
	})

	return items
end

M.indicator = function(bufnr)
	local diagnostic_count = M.count(bufnr)
	local tbl = {}
	for level, count in pairs(diagnostic_count) do
		if count > 0 then
			table.insert(tbl, M.signs[level].text .. count)
		end
	end
	return table.concat(tbl, " ")
end

return M
