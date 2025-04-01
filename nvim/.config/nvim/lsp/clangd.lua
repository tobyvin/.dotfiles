---@type vim.lsp.Config
return {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_markers = {
		".clangd",
		".clang-tidy",
		".clang-format",
		"compile_commands.json",
		"compile_flags.txt",
		"configure.ac",
		".git",
	},
	capabilities = {
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
		offsetEncoding = { "utf-8", "utf-16" },
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "ClangdSwitchSourceHeader", function()
			local params = vim.lsp.util.make_text_document_params(bufnr)
			client:request("textDocument/switchSourceHeader", params, function(err, result)
				if err then
					error(tostring(err))
				end
				if not result then
					vim.notify("corresponding file cannot be determined")
					return
				end
				vim.cmd.edit(vim.uri_to_fname(result))
			end, bufnr)
		end, { desc = "Switch between source/header" })

		vim.api.nvim_buf_create_user_command(bufnr, "ClangdShowSymbolInfo", function()
			local params = vim.lsp.util.make_text_document_params(bufnr)
			client:request("textDocument/symbolInfo", params, function(err, result)
				if err or #result == 0 then
					return
				end

				local container = ("container: %s"):format(result[1].containerName)
				local name = ("name: %s"):format(result[1].name)
				vim.lsp.util.open_floating_preview({ name, container }, "", {
					height = 2,
					width = math.max(string.len(name), string.len(container)),
					focusable = false,
					focus = false,
					border = vim.o.winborder,
					title = "Symbol Info",
				})
			end, bufnr)
		end, { desc = "Show symbol info" })
	end,
}
