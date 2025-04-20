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
	root_markers = { ".sln", ".csproj", "omnisharp.json", "function.json" },
	init_options = {},
	capabilities = {
		workspace = {
			workspaceFolders = false, -- https://github.com/OmniSharp/omnisharp-roslyn/issues/909
		},
	},
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
			EnableDecompilationSupport = nil,
		},
		RenameOptions = {
			RenameInComments = nil,
			RenameOverloads = nil,
			RenameInStrings = nil,
		},
		Sdk = {
			IncludePrereleases = true,
		},
	},
}
