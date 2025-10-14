vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("build_system", { clear = true }),
	pattern = "*",
	callback = function(args)
		local pkg = args.data
		local build_fn = (pkg.spec.data or {}).build
		if pkg.kind == "update" and type(build_fn) == "function" then
			pcall(build_fn, pkg)
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
			build = function(_)
				vim.cmd("TSUpdate")
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
			build = function(_)
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
		data = {
			build = function(pkg)
				vim.system({ "sh" }, {
					cwd = pkg.path,
					stdin = "make",
				})
			end,
		},
	},
	{
		src = "https://github.com/f3fora/nvim-texlabconfig",
		data = {
			build = function(pkg)
				vim.system({ "sh" }, {
					cwd = pkg.path,
					stdin = ("go build -o %s"):format(vim.fs.joinpath(vim.env.HOME, ".local/bin/")),
				})
			end,
		},
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
