---@class lsp.server.opts
---@field handlers table<string,fun(method: string, params: any, callback: function)>
---@field on_request fun(method: string, params: any)?
---@field on_notify fun(method: string, params: any)?
---@field capabilities table

--- Create a in-process LSP server that can be used as `cmd` with |vim.lsp.start|
--- Example:
--- <pre>lua
--- vim.lsp.start({
---   name = "my-in-process-server",
---   cmd = vim.lsp.server({
---   handlers = {
---
---   }
---   })
--- })
---
--- Ref: https://github.com/neovim/neovim/pull/24338
---
--- @param opts nil|lsp.server.opts
function vim.lsp.server(opts)
	opts = opts or {}
	local capabilities = opts.capabilities or {}
	local on_request = opts.on_request or function(_, _) end
	local on_notify = opts.on_notify or function(_, _) end
	local handlers = opts.handlers or {}

	return function(dispatchers)
		local closing = false
		local srv = {}
		local request_id = 0

		---@param method string
		---@param params any
		---@param callback fun(method: string?, params: any)
		---@return boolean
		---@return integer
		function srv.request(method, params, callback)
			pcall(on_request, method, params)
			local handler = handlers[method]
			if handler then
				handler(method, params, callback)
			elseif method == "initialize" then
				callback(nil, {
					capabilities = capabilities,
				})
			elseif method == "shutdown" then
				callback(nil, nil)
			end
			request_id = request_id + 1
			return true, request_id
		end

		---@param method string
		---@param params any
		function srv.notify(method, params)
			pcall(on_notify, method, params)
			if method == "exit" then
				dispatchers.on_exit(0, 15)
			end
		end

		---@return boolean
		function srv.is_closing()
			return closing
		end

		function srv.terminate()
			closing = true
		end

		return srv
	end
end
