local utils = require("tobyvin.utils")
local M = {}

M.plugins = function(use)
	use("wbthomason/packer.nvim")

	use({
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
		config = [[vim.g.startuptime_tries = 3]],
	})

	use("lewis6991/impatient.nvim")

	use({ "rcarriga/nvim-notify", config = [[require("tobyvin.plugins.notify").setup()]] })
	use("stevearc/dressing.nvim")

	use("andweeb/presence.nvim")

	use({ "eddyekofo94/gruvbox-flat.nvim", config = [[require("tobyvin.plugins.gruvbox-flat").setup()]] })

	use({
		"rmagatti/auto-session",
		config = [[require("auto-session").setup()]],
	})

	use({
		"rmagatti/session-lens",
		requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
		config = [[require("tobyvin.plugins.session-lens").setup()]],
	})

	use({
		"tpope/vim-dispatch",
		cmd = {
			"Dispatch",
			"Make",
			"Focus",
			"Start",
		},
	})

	use({
		"neovim/nvim-lspconfig",
		requires = {
			"williamboman/nvim-lsp-installer",
			"ray-x/lsp_signature.nvim",
		},
		config = [[require("tobyvin.plugins.lspconfig").setup()]],
	})

	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = [[require("tobyvin.plugins.null-ls").setup()]],
	})

	use({
		"folke/lua-dev.nvim",
		requires = {
			"neovim/nvim-lspconfig",
		},
		config = [[require("tobyvin.plugins.lua-dev").setup()]],
	})

	use({
		"simrat39/rust-tools.nvim",
		branch = "modularize_and_inlay_rewrite",
		requires = {
			"neovim/nvim-lspconfig",
		},
		config = [[require("tobyvin.plugins.rust-tools").setup()]],
	})

	use({
		"brymer-meneses/grammar-guard.nvim",
		requires = {
			"neovim/nvim-lspconfig",
			"williamboman/nvim-lsp-installer",
		},
		config = [[require("grammar-guard").init()]],
	})

	-- use({
	-- 	"saecki/crates.nvim",
	-- 	requires = { "nvim-lua/plenary.nvim" },
	-- 	config = [[require("crates").setup()]],
	-- })

	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "onsails/lspkind-nvim", config = [[require("tobyvin.plugins.lspkind")]] },
			"ray-x/lsp_signature.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-calc",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
		config = [[require("tobyvin.plugins.cmp")]],
	})

	use({ "simrat39/symbols-outline.nvim", config = [[require("symbols-outline").setup()]] })

	use({
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	})

	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"BurntSushi/ripgrep",
			"nvim-telescope/telescope-dap.nvim",
			"nvim-telescope/telescope-packer.nvim",
			"nvim-telescope/telescope-github.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
			{ "nvim-telescope/telescope-smart-history.nvim", requires = { "tami5/sqlite.lua", module = "sqlite" } },
			{ "nvim-telescope/telescope-frecency.nvim", requires = { "tami5/sqlite.lua", module = "sqlite" } },
		},
		config = [[require("tobyvin.plugins.telescope").setup()]],
	})

	use({
		"AckslD/nvim-neoclip.lua",
		requires = {
			{ "tami5/sqlite.lua", module = "sqlite" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = [[require("tobyvin.plugins.neoclip").setup()]],
	})

	use({
		"L3MON4D3/LuaSnip",
		requires = "rafamadriz/friendly-snippets",
		config = [[require("tobyvin.plugins.luasnip")]],
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		requires = {
			"nvim-treesitter/nvim-treesitter-refactor",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/nvim-treesitter-context",
			"JoosepAlviste/nvim-ts-context-commentstring",
			"mfussenegger/nvim-ts-hint-textobject",
		},
		config = [[require("tobyvin.plugins.treesitter").setup()]],
	})

	use({
		"ThePrimeagen/refactoring.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = [[require("tobyvin.plugins.refactoring").setup()]],
	})

	use({
		"danymat/neogen",
		requires = "nvim-treesitter/nvim-treesitter",
		config = [[require("tobyvin.plugins.neogen").setup()]],
	})

	use("norcalli/nvim-colorizer.lua")

	use({
		"lukas-reineke/indent-blankline.nvim",
		config = [[require("tobyvin.plugins.blankline")]],
	})

	use({ "lukas-reineke/virt-column.nvim", config = [[require("virt-column").setup()]] })
	use("tpope/vim-eunuch")

	use({
		"nvim-lualine/lualine.nvim",
		requires = {
			{ "kyazdani42/nvim-web-devicons" },
		},
		config = [[require("tobyvin.plugins.lualine")]],
	})

	use({
		"TimUntersberger/neogit",
		config = [[require("tobyvin.plugins.neogit").setup()]],
	})

	if vim.fn.executable("gh") == 1 then
		use("pwntester/octo.nvim")
	end

	use({
		"lewis6991/gitsigns.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = [[require("tobyvin.plugins.gitsigns")]],
	})

	use({
		"f-person/git-blame.nvim",
		config = [[require("tobyvin.plugins.git-blame")]],
	})

	use({
		"sindrets/diffview.nvim",
		requires = "nvim-lua/plenary.nvim",
	})

	use({
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		config = [[vim.g.undotree_SetFocusWhenToggle = 1]],
	})

	use({
		"ThePrimeagen/git-worktree.nvim",
		config = [[require("tobyvin.plugins.git-worktree")]],
	})

	use({
		"folke/which-key.nvim",
		config = [[require("tobyvin.plugins.which-key").setup()]],
	})

	use({
		"mfussenegger/nvim-dap",
		requires = {
			"theHamsta/nvim-dap-virtual-text",
			"rcarriga/nvim-dap-ui",
			"Pocco81/DAPInstall.nvim",
		},
		config = [[require("tobyvin.plugins.dap").setup()]],
	})

	use({ "antoinemadec/FixCursorHold.nvim", config = [[vim.g.curshold_updatime = 1000]] })
	use("nacro90/numb.nvim")
	use("ThePrimeagen/harpoon")
	use("b0o/SchemaStore.nvim")
	use("windwp/nvim-spectre")
	use("ggandor/lightspeed.nvim")
	use({ "ur4ltz/surround.nvim", config = [[require("surround").setup({mappings_style = "surround"})]] })

	use({
		"numToStr/Comment.nvim",
		config = [[require("Comment").setup()]],
	})

	use({ "famiu/bufdelete.nvim", config = [[require("tobyvin.plugins.bufdelete").setup()]] })
	use({
		"akinsho/nvim-bufferline.lua",
		requires = "kyazdani42/nvim-web-devicons",
		config = [[require("tobyvin.plugins.bufferline")]],
	})
	use({
		"goolord/alpha-nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = [[require("alpha").setup(require("alpha.themes.theta").config)]],
	})

	use("SmiteshP/nvim-gps")

	if PackerBootstrap then
		require("packer").sync()
	end
end

M.open_log = function()
	utils.popup(vim.fn.stdpath("cache") .. "/packer.nvim.log")
end

M.setup = function()
	local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if vim.fn.empty(vim.fn.glob(install_path, nil, nil, nil)) > 0 then
		PackerBootstrap = vim.fn.system({
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
		})
		vim.notify("Installing packer. Reload neovim to load plugins.", "info", { title = "[packer] Installing" })
		vim.cmd([[packadd packer.nvim]])
	end

	local status_ok, packer = pcall(require, "packer")
	if not status_ok then
		vim.notify("Failed to load module 'packer'", "error")
		return
	end

	packer.init({
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "rounded" })
			end,
		},
		autoremove = false,
	})

	local augroup_packer = vim.api.nvim_create_augroup("Packer", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = augroup_packer,
		pattern = "plugins.lua",
		callback = function()
			utils.reload("tobyvin.plugins")
			packer.sync()
		end,
		desc = "Reload packer config on write",
	})

	local nmap = utils.create_map_group("n", "<leader>p", "Packer")

	nmap("c", packer.compile, { desc = "Compile" })
	nmap("C", packer.clean, { desc = "Clean" })
	nmap("i", packer.install, { desc = "Install" })
	nmap("s", packer.sync, { desc = "Sync" })
	nmap("S", packer.status, { desc = "Status" })
	nmap("u", packer.update, { desc = "Update" })
	nmap("l", M.open_log, { desc = "Log" })

	-- Install your plugins here
	return packer.startup(M.plugins)
end

return M
