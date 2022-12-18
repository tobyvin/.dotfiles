local utils = require("tobyvin.utils")

local location_handler = vim.lsp.handlers["textDocument/definition"]
local definition_handler = function(err, result, ctx, config)
	if not result or vim.tbl_isempty(result) then
		vim.notify("No location found", vim.log.levels.INFO, { title = "[LSP] " .. ctx.method })
	elseif vim.tbl_islist(result) then
		result = result[1]
	end

	location_handler(err, result, ctx, config)
end

local show_message = function(_, result, ctx)
	vim.notify(string.format("%s", result.message), 5 - result.type, {
		title = string.format("[LSP] %s", vim.lsp.get_client_by_id(ctx.client_id)),
	})
end

local hover_ops = { border = "single" }
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, hover_ops)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, hover_ops)
vim.lsp.handlers["textDocument/definition"] = definition_handler
vim.lsp.handlers["window/showMessage"] = show_message

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("tobyvin_lsp_handlers", { clear = true }),
	desc = "setup lsp handlers",
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client.server_capabilities["definitionProvider"] then
			vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
		end

		utils.hover.register(vim.lsp.buf.hover, { desc = "lsp", buffer = bufnr, priority = 1 })

		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "signature help", buffer = bufnr })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "definition", buffer = bufnr })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "declaration", buffer = bufnr })
		vim.keymap.set("n", "go", vim.lsp.buf.type_definition, { desc = "type definition", buffer = bufnr })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "implementation", buffer = bufnr })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "references", buffer = bufnr })

		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "rename", buffer = bufnr })
		vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "code action", buffer = bufnr })
		vim.keymap.set("n", "<leader>ll", vim.lsp.codelens.run, { desc = "codelens", buffer = bufnr })
	end,
})
