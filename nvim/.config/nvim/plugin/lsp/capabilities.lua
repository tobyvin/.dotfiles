local ms = vim.lsp.protocol.Methods

-- Map of LSP capabilites and setup functions for supporting clients
---@type table<string, fun(bufnr:number, client:vim.lsp.Client)>
local capabilities = {
	[ms.completionItem_resolve] = function(bufnr, client)
		vim.api.nvim_create_autocmd("CompleteChanged", {
			buffer = bufnr,
			callback = function()
				local info = vim.fn.complete_info({ "selected" })
				local completionItem = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
				if completionItem == nil then
					return
				end
				client:request(ms.completionItem_resolve, completionItem, function(err, result)
					if err ~= nil then
						vim.notify(vim.inspect(err), vim.log.levels.ERROR)
						return
					end
					if result and result.documentation then
						local winData = vim.api.nvim__complete_set(info.selected, {
							info = result.documentation.value,
						})
						if winData.winid ~= nil and vim.api.nvim_win_is_valid(winData.winid) then
							vim.api.nvim_win_set_config(winData.winid, {
								height = #vim.api.nvim_buf_get_lines(winData.bufnr, 0, 10, false),
								border = vim.o.winborder == "" and "none" or vim.o.winborder --[[@as string]],
							})
							vim.treesitter.start(winData.bufnr, "markdown")
							vim.wo[winData.winid].conceallevel = 3
						end
					end
				end, bufnr)
			end,
		})
	end,
	[ms.dollar_progress] = function(_, client)
		-- See: https://github.com/neovim/neovim/pull/26098
		client.progress = vim.ringbuf(2048) --[[@as vim.lsp.Client.Progress]]
		client.progress.pending = {}
	end,
	[ms.textDocument_documentHighlight] = function(bufnr)
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
			desc = "vim.lsp.buf.document_highlight()",
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
			desc = "vim.lsp.buf.clear_references()",
		})
	end,
	[ms.textDocument_completion] = function(bufnr, client)
		vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

		vim.keymap.set("i", "<CR>", function()
			return vim.fn.pumvisible() ~= 0 and "<C-y>" or "<CR>"
		end, { desc = "complete accept", expr = true })

		vim.keymap.set("i", "<C-n>", function()
			if vim.fn.pumvisible() ~= 0 then
				return "<C-n>"
			elseif next(vim.lsp.get_clients({ bufnr = 0 })) then
				vim.lsp.completion.get()
				return "<Ignore>"
			elseif vim.bo.omnifunc == "" then
				return "<C-x><C-n>"
			else
				return "<C-x><C-o>"
			end
		end, { desc = "complete", expr = true })
	end,
	[ms.textDocument_typeDefinition] = function(bufnr)
		vim.keymap.set("n", "go", vim.lsp.buf.type_definition, {
			buffer = bufnr,
			desc = "vim.lsp.buf.type_definition()",
		})
	end,
	[ms.textDocument_inlayHint] = function(bufnr)
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end,
}

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user.lsp", { clear = true }),
	desc = "setup lsp capabilities",
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			for method, setup in pairs(capabilities) do
				if client:supports_method(method, args.buf) then
					setup(args.buf, client)
				end
			end
		end
	end,
})
