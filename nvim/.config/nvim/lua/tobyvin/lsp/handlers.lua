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
			end

			if client.server_capabilities["definitionProvider"] then
				vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
			end

			utils.hover.register(vim.lsp.buf.hover, { desc = "lsp", buffer = bufnr, priority = 1 })

			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "signature help", buffer = bufnr })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "definition", buffer = bufnr })
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "declaration", buffer = bufnr })
			vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "type definition", buffer = bufnr })
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "implementation", buffer = bufnr })
			vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "references", buffer = bufnr })

			vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "rename", buffer = bufnr })
			vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "code action", buffer = bufnr })
			vim.keymap.set("n", "<leader>ll", vim.lsp.codelens.run, { desc = "codelens", buffer = bufnr })
		end,
	})
end

return M
