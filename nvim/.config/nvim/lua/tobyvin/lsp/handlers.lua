local utils = require("tobyvin.utils")
local M = {}

M.wrap_handler = function(method, handler)
	handler = vim.F.if_nil(handler, vim.lsp.handlers[method])
	return function(err, result, ctx, config)
		if result == nil or vim.tbl_isempty(result) then
			vim.notify("No location found", vim.log.levels.INFO, { title = "[LSP] " .. ctx.method })
			return nil
		end

		if vim.tbl_islist(result) then
			result = result[1]
		end
		handler(err, result, ctx, config)
	end
end

M.with_float = function(name)
	local method = string.format("textDocument/%s", name)
	local handler = M.wrap_handler(method, function(_, result)
		vim.lsp.util.preview_location(result, {
			focus_id = "preview_" .. name,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "single",
			scope = "cursor",
		})
	end)

	return function()
		---@diagnostic disable-next-line: missing-parameter
		local params = vim.lsp.util.make_position_params()
		return vim.lsp.buf_request(0, method, params, handler)
	end
end

M.setup = function()
	vim.lsp.handlers["textDocument/publishDiagnostics"] =
		vim.lsp.with(vim.lsp.handlers["textDocument/publishDiagnostics"], {
			signs = true,
			underline = true,
			update_in_insert = true,
			virtual_text = true,
		})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

	vim.lsp.handlers["textDocument/signatureHelp"] =
		vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })

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

			if client.name ~= "rust_analyzer" then
				vim.lsp.handlers["textDocument/definition"] = M.wrap_handler("textDocument/definition")
				vim.lsp.handlers["textDocument/declaration"] = M.wrap_handler("textDocument/declaration")
				vim.lsp.handlers["textDocument/type_definition"] = M.wrap_handler("textDocument/type_definition")
				vim.lsp.handlers["textDocument/implementation"] = M.wrap_handler("textDocument/implementation")
				vim.lsp.handlers["textDocument/references"] = M.wrap_handler("textDocument/references")
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

			utils.keymap.group("n", "gf", { desc = "Float" })
			vim.keymap.set("n", "gfd", M.with_float("definition"), { desc = "Definition", buffer = bufnr })
			vim.keymap.set("n", "gfD", M.with_float("declaration"), { desc = "Declaration", buffer = bufnr })
			vim.keymap.set("n", "gft", M.with_float("type_definition"), { desc = "Type", buffer = bufnr })
			vim.keymap.set("n", "gfi", M.with_float("implementation"), { desc = "Implementation", buffer = bufnr })
			vim.keymap.set("n", "gfr", M.with_float("references"), { desc = "References", buffer = bufnr })

			vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action", buffer = bufnr })
			vim.keymap.set("n", "<leader>ll", vim.lsp.codelens.run, { desc = "Codelens", buffer = bufnr })
			vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename", buffer = bufnr })
		end,
	})
end

return M
