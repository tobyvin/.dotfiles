local augroup = vim.api.nvim_create_augroup("lsp_workspace", {})
local handlers = vim.lsp.handlers

function vim.lsp.buf.external_docs()
	local params = vim.lsp.util.make_position_params(nil, "")
	return vim.lsp.buf_request(0, "experimental/externalDocs", params)
end

return {
	["textDocument/definition"] = function(err, result, ctx, config)
		if not result or vim.tbl_isempty(result) then
			vim.notify("No location found", vim.log.levels.INFO, { title = "[LSP] " .. ctx.method })
		elseif vim.tbl_islist(result) then
			result = result[1]
		end

		local original = vim.lsp.buf.list_workspace_folders()

		handlers["textDocument/definition"](err, result, ctx, config)

		local workspaces = vim.lsp.buf.list_workspace_folders()

		-- TODO: rework this to reload LSP and reset diagnostics, as it is not done
		-- when removing the workspace folder. Possibly move into a LspRequest autocmd
		if original ~= workspaces then
			for _, workspace in ipairs(workspaces) do
				if not vim.tbl_contains(original, workspace) then
					vim.api.nvim_create_autocmd("BufDelete", {
						group = augroup,
						buffer = vim.api.nvim_get_current_buf(),
						callback = function()
							local autocmds = vim.api.nvim_get_autocmds({ group = augroup, event = "BufDelete" })

							if #autocmds <= 1 then
								vim.lsp.buf.remove_workspace_folder(workspace)
							end

							return true
						end,
						desc = "remove temporary workspace",
					})
				end
			end
		end
	end,

	["experimental/externalDocs"] = function(err, result, ctx, config)
		if handlers["experimental/externalDocs"] then
			result, err = handlers["experimental/externalDocs"](err, result, ctx, config)
		elseif result then
			vim.fn["netrw#BrowseX"](result, 0)
		end
	end,

	["window/showMessage"] = function(_, result, ctx)
		vim.notify(string.format("%s", result.message), 5 - result.type, {
			title = string.format("[LSP] %s", vim.lsp.get_client_by_id(ctx.client_id)),
		})
	end,

	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "single",
	}),

	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "single",
	}),
}
