local builds = {}
local augroup = vim.api.nvim_create_augroup("build", { clear = true })
vim.api.nvim_create_autocmd("PackChanged", {
	group = augroup,
	pattern = "*",
	callback = function(args)
		local pkg = args.data
		if pkg.kind ~= "delete" and pkg.spec.data then
			local build_fn
			if type(pkg.spec.data.build) == "function" then
				build_fn = function()
					return pcall(pkg.spec.data.build, pkg)
				end
			elseif type(pkg.spec.data.build) == "table" and vim.islist(pkg.spec.data.build) then
				build_fn = function()
					return vim.system(pkg.spec.data.build, {
						cwd = pkg.path,
						text = true,
					})
						:wait().code == 0
				end
			elseif type(pkg.spec.data.build) == "string" then
				build_fn = function()
					return pcall(vim.cmd[pkg.spec.data.build])
				end
			end

			if build_fn then
				builds[pkg.spec.name] = build_fn
			end
		end
	end,
})

vim.pack.add({
	{
		src = "https://github.com/ellisonleao/gruvbox.nvim",
		version = vim.version.range("*"),
	},
	{
		src = "https://github.com/emmanueltouzery/plenary.nvim",
		version = "winborder",
	},
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
		data = {
			build = function()
				local update = require("nvim-treesitter").update()
				if #vim.api.nvim_list_uis() == 0 then
					update:wait(300000)
				end
			end,
		},
	},
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
		version = "main",
	},
	{
		src = "https://github.com/stevearc/oil.nvim",
		version = vim.version.range("*"),
	},
	{
		src = "https://github.com/williamboman/mason.nvim",
		data = {
			build = function()
				require("mason.api.command").MasonUpdate()
			end,
		},
	},
	{
		src = "https://github.com/mfussenegger/nvim-lint",
		version = vim.version.range("*"),
	},
	{
		src = "https://github.com/stevearc/conform.nvim",
		version = vim.version.range("*"),
	},
	{
		src = "https://github.com/lewis6991/gitsigns.nvim",
		version = vim.version.range("*"),
	},
	{
		src = "https://github.com/j-hui/fidget.nvim",
		version = vim.version.range("*"),
	},
	{
		src = "https://github.com/codethread/qmk.nvim",
		version = vim.version.range("*"),
	},
	{
		src = "https://github.com/3rd/image.nvim",
		version = vim.version.range("*"),
	},
	"https://github.com/kiyoon/magick.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-live-grep-args.nvim",
	"https://github.com/debugloop/telescope-undo.nvim",
	{
		src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
		data = { build = { "make" } },
	},
	{
		src = "https://github.com/f3fora/nvim-texlabconfig",
		data = { build = { "go", "build", "-o", vim.fs.joinpath(vim.env.HOME, ".local/bin/") } },
	},
	"https://github.com/Bilal2453/luvit-meta",
	"https://github.com/LuaCATS/tex-luatex",
	"https://github.com/LuaCATS/tex-lualatex",
	"https://github.com/LuaCATS/tex-luametatex",
	"https://github.com/LuaCATS/tex-lualibs",
	"https://github.com/disco0/mpv-types-lua",
	"https://gitlab.com/carsakiller/cc-tweaked-documentation.git",
	{
		src = "https://github.com/folke/lazydev.nvim",
		version = vim.version.range("*"),
	},
	"https://github.com/vxpm/ferris.nvim",
	"https://github.com/mfussenegger/nvim-jdtls",
	"https://github.com/microsoft/python-type-stubs",
	"https://github.com/b0o/SchemaStore.nvim",
	"https://github.com/NvChad/nvim-colorizer.lua",
	"https://github.com/tridactyl/vim-tridactyl",
	"https://github.com/hjson/vim-hjson",
	"https://github.com/nfnty/vim-nftables",
	"https://github.com/wilriker/gcode.vim",
	"https://github.com/andweeb/presence.nvim",
	"https://github.com/eandrju/cellular-automaton.nvim",
	"https://github.com/rktjmp/playtime.nvim",
}, {
	confirm = #vim.api.nvim_list_uis() ~= 0,
})

if #builds > 0 then
	local progress = {
		kind = "progress",
		status = "running",
		title = "build",
	}

	progress.id = vim.api.nvim_echo({ { "Building plugins..." } }, true, progress)

	for pkg_name, build_fn in pairs(builds) do
		progress.status = "running"
		vim.api.nvim_echo({ { ("Building %s..."):format(pkg_name) } }, true, progress)
		local success, err = build_fn()
		if not success then
			progress.status = "failed"
			local msg = "failed to build"
			if err then
				msg = ("%s: %s"):format(msg, err)
			end
			vim.api.nvim_echo({ { msg, "ErrorMsg" } }, true, progress)
		end
	end

	progress.status = "success"
	vim.api.nvim_echo({ { "done" } }, true, progress)

	builds = {}
end
