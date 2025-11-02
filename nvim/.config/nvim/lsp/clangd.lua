---@type vim.lsp.Config
local M = {
	cmd = function(dispatchers, config)
		local cmd = { "clangd" }
		local files = vim.fs.find("compile_commands.json", { type = "file" })
		if files[1] then
			table.insert(cmd, ("--compile-commands-dir=%s"):format(vim.fs.dirname(files[1])))
		end

		return vim.lsp.rpc.start(cmd, dispatchers, {
			cwd = config.cmd_cwd,
			env = config.cmd_env,
			detached = config.detached,
		})
	end,
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
	---@param init_result { offsetEncoding?: string }
	on_init = function(client, init_result)
		if init_result.offsetEncoding then
			client.offset_encoding = init_result.offsetEncoding
		end
	end,
	on_attach = function(client, bufnr)
		-- client.server_capabilities.documentFormattingProvider = false
		-- client.server_capabilities.documentRangeFormattingProvider = false

		vim.api.nvim_buf_create_user_command(bufnr, "ClangdSwitchSourceHeader", function()
			local params = vim.lsp.util.make_text_document_params(bufnr)
			---@diagnostic disable-next-line: param-type-mismatch
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
			---@diagnostic disable-next-line: param-type-mismatch
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

return M
