---@diagnostic disable: missing-parameter
local M = {}

---@alias ProviderHandler fun():boolean? The handler for hover. Return true to indicate failure and skip
---@alias ProviderId number

---@class ProviderOpts
---@field enabled fun():boolean?
---@field buffer number?
---@field priority number?

---@class Provider
---@field handler ProviderHandler
---@field opts ProviderOpts

---@type Provider[]
vim.g.hover_providers = {}

local default_opts = {
	enabled = function()
		return true
	end,
}

---@param buffer number?
---@return Provider[]
local get_providers = function(buffer)
	if buffer then
		return vim.F.if_nil(vim.b[buffer].hover_providers, {})
	else
		return vim.g.hover_providers
	end
end

---@param buffer number?
---@param providers Provider[]
local set_providers = function(buffer, providers)
	if buffer == nil then
		vim.g.hover_providers = providers
	else
		vim.b[buffer].hover_providers = providers
	end
end

---@param a Provider
---@param b Provider
---@return boolean
local sort_providers = function(a, b)
	if a.opts.priority and b.opts.priority then
		return a.opts.priority > b.opts.priority
	else
		return not b.opts.priority
	end
end

---@param buffer number
---@return Provider[]
M.buf_providers = function(buffer)
	local providers = {}
	if vim.api.nvim_buf_is_valid(buffer) and type(vim.b[buffer].hover_providers) == "table" then
		vim.list_extend(providers, get_providers(buffer))
	end
	vim.list_extend(providers, get_providers())
	table.sort(providers, sort_providers)
	return providers
end

---@param handler ProviderHandler
---@param opts ProviderOpts
---@return ProviderId
M.register = function(handler, opts)
	---@type ProviderOpts
	opts = vim.F.if_nil(opts, {})
	opts = vim.tbl_extend("keep", opts, default_opts)

	---@type Provider
	local provider = { handler = handler, opts = opts }

	local providers = get_providers(provider.opts.buffer)
	local id

	if #providers > 0 and provider.opts.priority then
		for i, p in ipairs(providers) do
			if not p.opts.priority or p.opts.priority < provider.opts.priority or i == #providers then
				table.insert(providers, i, provider)
				id = i
				break
			end
		end
	else
		table.insert(providers, provider)
		id = #providers
	end

	set_providers(provider.opts.buffer, providers)
	return id
end

---@param id ProviderId
---@param buffer number?
M.unregister = function(id, buffer)
	local providers = get_providers(buffer)

	local provider = table.remove(providers, id)

	set_providers(buffer, providers)
	return provider
end

---@param buffer number?
M.open = function(buffer)
	buffer = buffer or vim.api.nvim_get_current_buf()
	local providers = M.buf_providers(buffer)
	for _, provider in ipairs(providers) do
		if provider.opts.enabled and provider.opts.enabled() and not provider.handler() then
			return true
		end
	end
end

return M
