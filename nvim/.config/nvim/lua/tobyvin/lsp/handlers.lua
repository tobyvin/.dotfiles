local M = {}

local handler_hook = function(method, pre_hook, post_hook)
	local original = vim.lsp.handlers[method]
	vim.lsp.handlers[method] = function(...)
		if pre_hook ~= nil then
			pre_hook(...)
		end
		original(...)
		if post_hook ~= nil then
			post_hook(...)
		end
	end
end

M.setup = function()
	handler_hook("textDocument/definition", function(_, result)
		if not result or vim.tbl_isempty(result) then
			vim.notify("[LSP] No definition found", vim.log.levels.INFO)
		end
	end)

	handler_hook("textDocument/implementation", function(_, result)
		if not result or vim.tbl_isempty(result) then
			vim.notify("[LSP] No implementations found", vim.log.levels.INFO)
		end
	end)

	vim.lsp.handlers["textDocument/publishDiagnostics"] =
		vim.lsp.with(vim.lsp.handlers["textDocument/publishDiagnostics"], {
			signs = true,
			underline = true,
			update_in_insert = true,
			virtual_text = true,
		})

	vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
		vim.notify({ result.message }, 5 - result.type, {
			title = "[LSP] " .. vim.lsp.get_client_by_id(ctx.client_id),
		})
	end
end

return M
