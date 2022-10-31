---@diagnostic disable: missing-parameter
local M = {}

M.providers = {}
M.buffers = {}

local default_opts = {
	enabled = function()
		return true
	end,
}

M.get_providers = function(buffer)
	if buffer == nil then
		return M.providers
	else
		return vim.F.if_nil(vim.b[buffer].hover_providers, {})
	end
end

M.set_providers = function(buffer, providers)
	if buffer == nil then
		M.providers = providers
	else
		vim.b[buffer].hover_providers = providers
	end
end

M.register = function(callback, opts)
	opts = vim.F.if_nil(opts, default_opts)
	local provider = vim.tbl_extend("keep", { callback = callback }, opts, default_opts)
	local buffer = provider.buffer
	local providers = M.get_providers(buffer)

	if #providers > 0 and provider.priority then
		for i, p in ipairs(providers) do
			if not p.priority or p.priority < provider.priority or i == #providers then
				table.insert(providers, i, provider)
				break
			end
		end
	else
		table.insert(providers, provider)
	end

	M.set_providers(buffer, providers)
end

M.open = function()
	local buffer = vim.api.nvim_get_current_buf()
	local providers = {}

	if vim.api.nvim_buf_is_valid(buffer) and type(vim.b[buffer].hover_providers) == "table" then
		vim.list_extend(providers, vim.b[buffer].hover_providers)
	end

	vim.list_extend(providers, M.providers)

	for _, provider in ipairs(providers) do
		if provider.enabled() and not provider.callback() then
			return true
		end
	end
end

return M
