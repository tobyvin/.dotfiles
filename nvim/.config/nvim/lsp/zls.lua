---@type vim.lsp.Config
return {
	cmd = { "zls" },
	filetypes = { "zig", "zir" },
	root_markers = { "zls.json", "build.zig", ".git" },
	before_init = function(params, config)
		if vim.fn.filereadable(vim.fs.joinpath(params.rootPath, "zls.json")) ~= 0 then
			config.cmd = { "zls", "--config-path", "zls.json" }
		end
	end,
}
