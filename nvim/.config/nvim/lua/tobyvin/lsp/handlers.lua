---@diagnostic disable: missing-parameter
local M = {}

M.goto_handler = function(method)
	local callback = vim.lsp.handlers[method]
	return function(err, result, ctx, config)
		if result == nil or vim.tbl_isempty(result) then
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

M.preview_handler = function(method)
	local preview_callback = function(_, result, _, _)
		if vim.tbl_islist(result) then
			vim.lsp.util.preview_location(result[1])
		else
			vim.lsp.util.preview_location(result)
		end
	end

	return function()
		local params = vim.lsp.util.make_position_params()
		return vim.lsp.buf_request(0, method, params, M.goto_handler(preview_callback))
	end
end

M.preview = {
	definition = M.preview_handler("textDocument/definition"),
	declaration = M.preview_handler("textDocument/declaration"),
	type_definition = M.preview_handler("textDocument/type_definition"),
	implementation = M.preview_handler("textDocument/implementation"),
	references = M.preview_handler("textDocument/references"),
}

M.setup = function()
	vim.lsp.handlers["textDocument/publishDiagnostics"] =
		vim.lsp.with(vim.lsp.handlers["textDocument/publishDiagnostics"], {
			signs = true,
			underline = true,
			update_in_insert = true,
			virtual_text = true,
		})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

	vim.lsp.handlers["textDocument/signatureHelp"] =
		vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

	vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
		vim.notify(result.message, 5 - result.type, {
			title = "[LSP] " .. vim.lsp.get_client_by_id(ctx.client_id),
		})
	end

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("tobyvin_lsp_handlers", { clear = true }),
		desc = "setup lsp handlers",
		callback = function(args)
			local bufnr = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)

			if client.name ~= "rust-analyzer" then
				vim.lsp.handlers["textDocument/definition"] = M.goto_handler("textDocument/definition")
				vim.lsp.handlers["textDocument/declaration"] = M.goto_handler("textDocument/declaration")
				vim.lsp.handlers["textDocument/type_definition"] = M.goto_handler("textDocument/type_definition")
				vim.lsp.handlers["textDocument/implementation"] = M.goto_handler("textDocument/implementation")
				vim.lsp.handlers["textDocument/references"] = M.goto_handler("textDocument/references")
			end

			if client.server_capabilities["definitionProvider"] then
				vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
			end

			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help", buffer = bufnr })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover", buffer = bufnr })

			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Definition", buffer = bufnr })
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration", buffer = bufnr })
			vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { desc = "Type", buffer = bufnr })
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation", buffer = bufnr })
			vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References", buffer = bufnr })

			vim.keymap.set("n", "g<C-d>", M.preview.definition, { desc = "Definition", buffer = bufnr })
			vim.keymap.set("n", "g<CS-D>", M.preview.declaration, { desc = "Preview Declaration", buffer = bufnr })
			vim.keymap.set("n", "g<C-t>", M.preview.type_definition, { desc = "Preview Type", buffer = bufnr })
			vim.keymap.set("n", "g<C-i>", M.preview.implementation, { desc = "Preview Implementation", buffer = bufnr })
			vim.keymap.set("n", "g<C-r>", M.preview.references, { desc = "Preview References", buffer = bufnr })

			vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action", buffer = bufnr })
			vim.keymap.set("n", "<leader>ll", vim.lsp.codelens.run, { desc = "Codelens", buffer = bufnr })
			vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename", buffer = bufnr })
		end,
	})
end

return M
