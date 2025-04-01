---@type vim.lsp.Config
return {
	cmd = {
		"omnisharp",
		"-z", -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
		"--languageserver",
		"--hostPID",
		tostring(vim.fn.getpid()),
		"DotNet:enablePackageRestore=false",
		"--encoding",
		"utf-8",
	},
	filetypes = { "cs", "vb" },
	root_markers = { "*.sln", "*.csproj", "omnisharp.json", "function.json" },
	settings = {
		FormattingOptions = {
			EnableEditorConfigSupport = true,
			OrganizeImports = nil,
		},
		MsBuild = {
			LoadProjectsOnDemand = nil,
		},
		RoslynExtensionsOptions = {
			EnableAnalyzersSupport = nil,
			EnableImportCompletion = nil,
			AnalyzeOpenDocumentsOnly = nil,
		},
		Sdk = {
			IncludePrereleases = true,
		},
	},
	before_init = function(_, config)
		local function flatten(tbl)
			local ret = {}
			for k, v in pairs(tbl) do
				if type(v) == "table" then
					for _, pair in ipairs(flatten(v)) do
						ret[#ret + 1] = k .. ":" .. pair
					end
				else
					ret[#ret + 1] = k .. "=" .. vim.inspect(v)
				end
			end
			return ret
		end
		if config.settings then
			---@diagnostic disable-next-line: param-type-mismatch
			vim.list_extend(config.cmd, flatten(config.settings))
		end

		config.capabilities = vim.deepcopy(config.capabilities)
		config.capabilities.workspace.workspaceFolders = false -- https://github.com/OmniSharp/omnisharp-roslyn/issues/909
	end,
}
