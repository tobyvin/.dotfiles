local latest = vim.version.range("*")
local gh = function(stub)
	return "https://github.com/" .. stub
end
local gl = function(stub)
	return "https://gitlab.com/" .. stub
end

local hooks = {
	["telescope-fzf-native.nvim"] = {
		kind = { "install", "update" },
		build = { "make" },
	},
	["nvim-texlabconfig"] = {
		kind = { "install", "update" },
		build = { "go", "build", "-o", vim.fs.joinpath(vim.env.HOME, ".local/bin/") },
	},
	["mason.nvim"] = {
		kind = { "update" },
		build = "MasonUpdate",
	},
	["nvim-treesitter"] = {
		kind = { "update" },
		build = function()
			local success, res = pcall(require("nvim-treesitter").update)
			if success and #vim.api.nvim_list_uis() == 0 then
				res:wait(300000)
			end
		end,
	},
}

vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("build_system", { clear = true }),
	callback = function(args)
		local pkg = args.data
		local hook = hooks[pkg.spec.name]
		local success, res
		if not hook or not vim.list_contains(hook.kind, pkg.kind) then
			return
		elseif type(hook.build) == "table" then
			success, res = pcall(vim.system, hook.build, { cwd = pkg.path })
			if success and #vim.api.nvim_list_uis() == 0 then
				res:wait(300000)
			end
		else
			if not pkg.active then
				vim.cmd.packadd(pkg.spec.name)
			end

			if type(hook.build) == "string" then
				success, res = pcall(vim.cmd[hook.build])
			elseif type(hook.build) == "function" then
				success, res = pcall(hook.build, pkg)
			end
		end

		if success == false then
			vim.notify(
				("Failed to build - %s: %s"):format(pkg.spec.name, res),
				vim.log.levels.ERROR,
				{ title = "vim.pack" }
			)
		end
	end,
})

vim.pack.add({
	gh("ellisonleao/gruvbox.nvim"),
	gh("nvim-lua/plenary.nvim"),
	{ src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
	{ src = gh("nvim-treesitter/nvim-treesitter-textobjects"), version = "main" },
	{ src = gh("stevearc/oil.nvim"), version = latest },
	{ src = gh("williamboman/mason.nvim"), version = latest },
	{ src = gh("stevearc/conform.nvim"), version = latest },
	gh("codethread/qmk.nvim"),
	gh("mfussenegger/nvim-lint"),
	{ src = gh("lewis6991/gitsigns.nvim"), version = latest },
	gh("nvim-telescope/telescope.nvim"),
	gh("nvim-telescope/telescope-live-grep-args.nvim"),
	gh("debugloop/telescope-undo.nvim"),
	gh("nvim-telescope/telescope-fzf-native.nvim"),
	{ src = gh("3rd/image.nvim"), version = latest },
	gh("kiyoon/magick.nvim"),
	{ src = gh("folke/lazydev.nvim"), version = latest },
	gh("Bilal2453/luvit-meta"),
	gh("LuaCATS/tex-luatex"),
	gh("LuaCATS/tex-lualatex"),
	gh("LuaCATS/tex-luametatex"),
	gh("LuaCATS/tex-lualibs"),
	gh("disco0/mpv-types-lua"),
	gl("carsakiller/cc-tweaked-documentation.git"),
	gh("f3fora/nvim-texlabconfig"),
	gh("vxpm/ferris.nvim"),
	gh("mfussenegger/nvim-jdtls"),
	gh("microsoft/python-type-stubs"),
	gh("b0o/SchemaStore.nvim"),
	gh("tridactyl/vim-tridactyl"),
	gh("hjson/vim-hjson"),
	gh("nfnty/vim-nftables"),
	gh("wilriker/gcode.vim"),
	gh("andweeb/presence.nvim"),
	gh("eandrju/cellular-automaton.nvim"),
	gh("rktjmp/playtime.nvim"),
}, {
	load = true,
	confirm = #vim.api.nvim_list_uis() ~= 0,
})
