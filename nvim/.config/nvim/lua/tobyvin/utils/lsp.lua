local M = {
	lsp_timeout_ms = 600000,
	lsp_restart_delay_ms = 1000,
}

---Register callback to run when a lsp server matching a filter attaches to a buffer
---@param filter string|string[]|vim.lsp.get_clients.Filter|vim.lsp.get_clients.Filter[]|nil
---@param on_attach fun(client: vim.lsp.Client, bufnr: integer): boolean|nil
---@param opts vim.api.keyset.create_autocmd?
function M.on_attach(filter, on_attach, opts)
	if type(filter) == "string" then
		filter = {
			name = filter,
		}
	end

	opts = opts or {}
	opts.callback = function(args)
		local bufnr = args.buf ---@type number
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if
			client
			and vim.iter({ filter }):all(function(f)
				return (f.id == nil or client.id == f.id)
					and (f.name == nil or client.name == f.name)
					and (f.bufnr == nil or bufnr == f.bufnr)
					and (f.method == nil or client.supports_method(f.method, { bufnr = bufnr }))
			end)
		then
			on_attach(client, bufnr)
		end
	end

	vim.api.nvim_create_autocmd("LspAttach", opts)
end

---@param client vim.lsp.Client
---@param bufnr integer
function M.initiate_timeout(client, bufnr)
	if vim.b[bufnr].timed_out then
		return
	end

	if vim.b[bufnr].restarting then
		vim.b[bufnr].restarting:stop()
	end

	vim.b[bufnr].lsp_timeout = vim.defer_fn(function()
		vim.b[bufnr].timed_out = true

		local timed_out = vim.iter(client.attached_buffers):all(function(buf)
			return vim.b[buf].timed_out
		end)

		if timed_out then
			client.stop()
			client.rpc.terminate()
		end
	end, M.lsp_timeout)
end

---@param client vim.lsp.Client
---@param bufnr integer
function M.initiate_restart(client, bufnr)
	if not vim.b[bufnr].timed_out then
		return
	end

	vim.b[bufnr].restarting = vim.defer_fn(function()
		vim.b[bufnr].lsp_timeout:stop()
		require("lspconfig.configs")[client.name].launch(bufnr)

		vim.b[bufnr].restarting:close()
		vim.b[bufnr].restarting = nil
		vim.b[bufnr].timed_out = nil
	end, M.lsp_restart_delay_ms)
end

---@param client vim.lsp.Client
---@param bufnr integer
function M.setup_timeout(client, bufnr)
	vim.api.nvim_create_autocmd("BufLeave", {
		buffer = bufnr,
		callback = function()
			M.initiate_timeout(client, bufnr)
		end,
	})

	vim.api.nvim_create_autocmd("BufEnter", {
		buffer = bufnr,
		callback = function()
			M.initiate_restart(client, bufnr)
		end,
	})
end

---Sends a notification.
---@param kind string Accepted values are:
---{ "lsp_has_started", "lsp_has_stopped" }
function M.notify(kind)
	if kind == "lsp_has_started" then
		vim.notify("Focus recovered. Starting LSP clients.", vim.log.levels.INFO, { title = "garbage-day.nvim" })
	elseif kind == "lsp_has_stopped" then
		vim.notify(
			"Inactive LSP clients have been stopped to save resources.",
			vim.log.levels.INFO,
			{ title = "garbage-day.nvim" }
		)
	end
end

return M
