local mod_cache = nil

---@type vim.lsp.Config
return {
	cmd = {
		"gopls",
		"serve",
	},
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = function(bufnr, cb)
		if not mod_cache then
			local obj = vim.system({ "go", "env", "GOMODCACHE" }, { text = true }):wait()
			if obj.code == 0 then
				mod_cache = vim.fs.normalize(vim.trim(obj.stdout))
			end
		end

		local root_dir
		if mod_cache and vim.startswith(vim.api.nvim_buf_get_name(bufnr), mod_cache) then
			local client = vim.iter(vim.lsp.get_clients({ name = "gopls" })):next()
			if client then
				root_dir = client.config.root_dir
			end
		end

		cb(root_dir or vim.fs.root(bufnr, { "go.work", "go.mod", ".git" }))
	end,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
}
