local M = {}

function M.inspect(v)
	print(vim.inspect(v))
	return v
end

--- Merges two or more highlights.
---@param ns integer Namespace
---@param name string name of new hl
---@param ... string|table|{ [1]: integer, [2]: string|table } Two or more hl names, definitions, or tuples of {ns, name|definition}
function M.extend_hl(ns, name, ...)
	local hl = {}

	for _, arg in pairs({ ... }) do
		local hl_name_or_val, hl_ns, hl_val
		if
			vim.tbl_islist(arg --[[@as table]])
		then
			hl_ns, hl_name_or_val = arg[1], arg[2]
		else
			hl_ns, hl_name_or_val = ns, arg --[[@as string|table]]
		end

		if type(hl_name_or_val) == "string" then
			hl_val = vim.api.nvim_get_hl(hl_ns, { name = hl_name_or_val, link = false })
		else
			hl_val = hl_name_or_val
		end

		hl = vim.tbl_extend("keep", hl, hl_val)
	end

	vim.api.nvim_set_hl(ns, name, hl)
end

return M
