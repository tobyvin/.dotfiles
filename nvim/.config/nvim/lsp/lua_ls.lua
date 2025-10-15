---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},
	on_init = function(client)
		if client.workspace_folders then
			local plug_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt")
			local path = client.workspace_folders[1].name
			local nvim_config = vim.fs.dirname(vim.fn.resolve(vim.fs.joinpath(vim.fn.stdpath("config"), "init.lua")))
			if
				path ~= vim.fn.stdpath("config")
				and path ~= nvim_config
				and vim.fs.normalize(vim.fs.dirname(path)) ~= plug_dir
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua --[[@as table]], {
			runtime = {
				version = "LuaJIT",
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		})
	end,

	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			format = {
				enable = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
