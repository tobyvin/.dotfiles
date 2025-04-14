---@type vim.lsp.Config
return {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git",
	},
	settings = {
		basedpyright = {
			typeCheckingMode = "standard",
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
			},
		},
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(0, "PyrightOrganizeImports", function()
			client:exec_cmd({
				title = "organizeimports",
				command = "basedpyright.organizeimports",
				arguments = { vim.uri_from_bufnr(bufnr) },
			}, { bufnr = bufnr })
		end, { desc = "Organize Imports" })

		vim.api.nvim_buf_create_user_command(0, "PyrightSetPythonPath", function(args)
			client.settings.python = vim.tbl_deep_extend("force", client.settings.python --[[@as table?]] or {}, {
				pythonPath = args.fargs[1],
			})
			client:notify("workspace/didChangeConfiguration", { settings = nil })
		end, {
			desc = "Reconfigure basedpyright with the provided python path",
			nargs = 1,
			complete = "file",
		})
	end,
}
