local ms = vim.lsp.protocol.Methods

---@type table<string, fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient>
local M = {}
local mt = {}

function mt.__call(t, name, opts)
	opts = vim.tbl_extend("keep", opts or {}, {
		capabilities = {},
		handlers = {},
	})

	vim.validate({
		name = { name, "string" },
		capabilities = { opts.capabilities, "table" },
		handlers = { opts.handlers, "table" },
	})

	t[name] = function(dispatchers)
		local closing = false
		local request_id = 0

		---@type vim.lsp.rpc.PublicClient
		---@diagnostic disable-next-line: missing-fields
		local srv = {}

		function srv.request(method, params, callback)
			if type(opts.handlers[method]) == "function" then
				opts.handlers[method](method, params, callback)
			elseif method == ms.initialize then
				callback(nil, { capabilities = opts.capabilities })
			elseif method == ms.shutdown then
				callback(nil, nil)
			end

			request_id = request_id + 1
			return true, request_id
		end

		---@diagnostic disable-next-line: unused-local
		function srv.notify(method, params)
			if method == "exit" then
				dispatchers.on_exit(0, 15)
			end

			return true
		end

		function srv.is_closing()
			return closing
		end

		function srv.terminate()
			closing = true
		end

		return srv
	end

	return t[name]
end

setmetatable(M, mt)

return M
