local server_capability_map = vim.lsp.protocol._request_name_to_server_capability

---@class lsp.server.opts
---@field on_request fun(method: string, params: any)?
---@field on_notify fun(method: string, params: any)?
---@field handlers table<vim.lsp.protocol.Method.ClientToServer,fun(method: string, params: any, callback: function)>

--- Create a in-process LSP server that can be used as `cmd` with |vim.lsp.start|
--- Example:
--- ```lua
--- vim.lsp.start({
---   name = "my-in-process-server",
---   cmd = vim.lsp.server({
---     handlers = {
---       ---@param params lsp.HoverParams
---       ["textDocument/hover"] = function(_, params, callback)
---         local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
---         local lnum = params.position.line
---         local col = params.position.character
---         -- use bufnr/lnum/col to provide actual text
---         callback({
---           contents = {
---             kind = "plaintext",
---             value = "just some dummy text",
---           }
---         })
---       end,
---     },
---   }),
--- })
--- ```
---
--- Ref: https://github.com/neovim/neovim/pull/24338
---
--- @param opts nil|lsp.server.opts
function vim.lsp.server(opts)
	opts = opts or {}
	local on_request = opts.on_request or function(_, _) end
	local on_notify = opts.on_notify or function(_, _) end
	local handlers = opts.handlers or {}
	local capabilities = {}
	for request_name, _ in pairs(handlers) do
		vim.list_extend(capabilities, server_capability_map[request_name] or {})
	end

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
