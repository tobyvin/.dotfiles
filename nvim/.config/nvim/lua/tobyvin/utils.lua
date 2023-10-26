local M = {}

function M.inspect(v)
	print(vim.inspect(v))
	return v
end

---@param on_attach fun(client: lsp.Client, buffer: integer): boolean|nil
---@param filter vim.lsp.get_clients.filter|nil
function M.on_attach(on_attach, filter)
	vim.api.nvim_create_autocmd("LspAttach", {
		desc = "on client attach",
		callback = function(args)
			local bufnr = args.buf ---@type number
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			filter = filter or {}

			if
				client
				and (filter.id == nil or client.id == filter.id)
				and (filter.name == nil or client.name == filter.name)
				and (filter.bufnr == nil or bufnr == filter.bufnr)
				and (filter.method == nil or client.supports_method(filter.method, { bufnr = bufnr }))
			then
				on_attach(client, bufnr)
			end
		end,
	})
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
