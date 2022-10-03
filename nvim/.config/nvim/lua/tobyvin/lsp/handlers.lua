---@diagnostic disable: missing-parameter
local M = {}

M.with_handler = function(callback)
	return function(err, result, ctx, config)
		if result == nil or vim.tbl_isempty(result) then
			vim.lsp.log.info(ctx.method, "No location found")
			vim.notify("No location found", vim.log.levels.INFO, { title = "[LSP] " .. ctx.method })
			return nil
		end

		-- workaround for LSPs returning two results on (2) anonymous function (1) variable assignments, e.g. this func
		if ctx.method == "textDocument/definition" and vim.tbl_islist(result) and #result > 1 then
			for _, k in pairs(vim.tbl_keys(result[1])) do
				if
					(k == "range" or k == "targetRange")
					and result[1][k].start ~= nil
					and result[1][k].start.line == result[2][k].start.line
				then
					result[2][k].start = result[1][k].start
					table.remove(result, 1)
					break
				end
			end
		end

		if vim.tbl_islist(result) and #result == 1 then
			result = result[1]
		end

		callback(err, result, ctx, config)
	end
end

M.with_preview = function(method)
	local preview_callback = function(_, result, _, _)
		if vim.tbl_islist(result) then
			vim.lsp.util.preview_location(result[1])
		else
			vim.lsp.util.preview_location(result)
		end
	end

	return function()
		local params = vim.lsp.util.make_position_params()
		return vim.lsp.buf_request(0, method, params, M.with_handler(preview_callback))
	end
end

M.preview = {}

M.setup = function()
	vim.lsp.handlers["textDocument/definition"] = M.with_handler(vim.lsp.handlers["textDocument/definition"])
	vim.lsp.handlers["textDocument/declaration"] = M.with_handler(vim.lsp.handlers["textDocument/declaration"])
	vim.lsp.handlers["textDocument/type_definition"] = M.with_handler(vim.lsp.handlers["textDocument/type_definition"])
	vim.lsp.handlers["textDocument/implementation"] = M.with_handler(vim.lsp.handlers["textDocument/implementation"])
	vim.lsp.handlers["textDocument/references"] = M.with_handler(vim.lsp.handlers["textDocument/references"])

	M.preview.definition = M.with_preview("textDocument/definition")
	M.preview.declaration = M.with_preview("textDocument/declaration")
	M.preview.type_definition = M.with_preview("textDocument/type_definition")
	M.preview.implementation = M.with_preview("textDocument/implementation")
	M.preview.references = M.with_preview("textDocument/references")

	vim.lsp.handlers["textDocument/publishDiagnostics"] =
		vim.lsp.with(vim.lsp.handlers["textDocument/publishDiagnostics"], {
			signs = true,
			underline = true,
			update_in_insert = true,
			virtual_text = true,
		})

	vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
		vim.notify(result.message, 5 - result.type, {
			title = "[LSP] " .. vim.lsp.get_client_by_id(ctx.client_id),
		})
	end
end

return M
