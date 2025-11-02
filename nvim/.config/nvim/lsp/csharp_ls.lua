---@type vim.lsp.Config
return {
	cmd = function(dispatchers, config)
		return vim.lsp.rpc.start({ "csharp-ls" }, dispatchers, {
			-- csharp-ls attempt to locate sln, slnx or csproj files from cwd, so set cwd to root directory.
			-- If cmd_cwd is provided, use it instead.
			cwd = config.cmd_cwd or config.root_dir,
			env = config.cmd_env,
			detached = config.detached,
		})
	end,
	root_dir = function(bufnr, cb)
		cb(vim.fs.root(bufnr, { "*.sln", "*.slnx", "*.csproj" }))
	end,
	filetypes = { "cs" },
	init_options = {
		AutomaticWorkspaceInit = true,
	},
}
