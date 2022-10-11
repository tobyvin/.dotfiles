---@diagnostic disable: missing-parameter
local utils = require("tobyvin.utils")
local M = {}

M.ensure_packer = function()
	local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
		vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

M.try_local = function(opts)
	if type(opts) == "string" then
		opts = { opts }
	end
	local local_path = vim.fn.expand("~/src/" .. vim.fs.basename(opts[1]))
	if vim.fn.isdirectory(local_path) == 1 then
		opts[1] = local_path
	end
	return opts
end

M.plugins = function(use)
	use("wbthomason/packer.nvim")

	use("lewis6991/impatient.nvim")

	use({
		"goolord/alpha-nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("tobyvin.plugins.alpha").setup()
		end,
	})

	use({
		"rcarriga/nvim-notify",
		event = "VimEnter",
		config = function()
			require("tobyvin.plugins.notify").setup()
		end,
	})

	use({
		"stevearc/dressing.nvim",
		config = function()
			require("tobyvin.plugins.dressing").setup()
		end,
	})

	use({
		"ellisonleao/gruvbox.nvim",
		config = function()
			require("tobyvin.plugins.gruvbox").setup()
		end,
	})

	use({
		"folke/tokyonight.nvim",
		config = function()
			require("tobyvin.plugins.tokyonight").setup()
		end,
	})

	use({
		"Shatur/neovim-session-manager",
		config = function()
			require("tobyvin.plugins.session_manager").setup()
		end,
	})

	use({
		"williamboman/mason.nvim",
		config = function()
			require("tobyvin.plugins.mason").setup()
		end,
	})

	use({
		"RubixDev/mason-update-all",
		requires = { "williamboman/mason.nvim" },
		config = function()
			require("tobyvin.plugins.mason-update-all").setup()
		end,
	})

	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("tobyvin.plugins.null-ls").setup()
		end,
	})

	use({
		"jayp0521/mason-null-ls.nvim",
		after = { "mason.nvim", "null-ls.nvim" },
		requires = {
			"williamboman/mason.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
		config = function()
			require("tobyvin.plugins.mason-null-ls").setup()
		end,
	})

	use({
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		requires = {
			"nvim-lua/plenary.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
		config = function()
			require("tobyvin.plugins.crates").setup()
		end,
	})

	use({
		"williamboman/mason-lspconfig.nvim",
		after = "mason.nvim",
		requires = {
			"williamboman/mason.nvim",
		},
		config = function()
			require("tobyvin.plugins.mason-lspconfig").setup()
		end,
	})

	use({
		"neovim/nvim-lspconfig",
		after = "mason-lspconfig.nvim",
		requires = {
			"ray-x/lsp_signature.nvim",
			"SmiteshP/nvim-navic",
			"barreiroleo/ltex-extra.nvim",
		},
		config = function()
			require("tobyvin.plugins.lspconfig").setup()
		end,
	})

	use({
		"folke/lua-dev.nvim",
		after = "nvim-lspconfig",
		requires = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("tobyvin.plugins.lua-dev").setup()
		end,
	})

	use({
		"simrat39/rust-tools.nvim",
		after = "nvim-lspconfig",
		requires = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("tobyvin.plugins.rust-tools").setup()
		end,
	})

	use({
		"brymer-meneses/grammar-guard.nvim",
		after = "nvim-lspconfig",
		requires = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("grammar-guard").init()
		end,
	})

	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"dmitmel/cmp-cmdline-history",
			"hrsh7th/cmp-calc",
			"ray-x/lsp_signature.nvim",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"rcarriga/cmp-dap",
			"petertriho/cmp-git",
			"Dosx001/cmp-commit",
			"davidsierradz/cmp-conventionalcommits",
			"saadparwaiz1/cmp_luasnip",
			"saecki/crates.nvim",
			"kdheepak/cmp-latex-symbols",
		},
		config = function()
			require("tobyvin.plugins.cmp").setup()
		end,
	})

	use({
		"petertriho/cmp-git",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("tobyvin.plugins.cmp-git").setup()
		end,
	})

	use({
		"David-Kunz/cmp-npm",
		event = { "BufRead package.json" },
		requires = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("tobyvin.plugins.cmp-npm").setup()
		end,
	})

	use({
		"onsails/lspkind-nvim",
		config = function()
			require("tobyvin.plugins.lspkind").setup()
		end,
	})

	use({
		"kevinhwang91/nvim-bqf",
		requires = {
			"nvim-treesitter/nvim-treesitter",
			"junegunn/fzf",
		},
		ft = "qf",
	})

	use({
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
		config = function()
			require("tobyvin.plugins.trouble").setup()
		end,
	})

	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"BurntSushi/ripgrep",
			{ "nvim-telescope/telescope-frecency.nvim", requires = { "kkharji/sqlite.lua" } },
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
			"nvim-telescope/telescope-dap.nvim",
			"nvim-telescope/telescope-packer.nvim",
			"nvim-telescope/telescope-github.nvim",
		},
		config = function()
			require("tobyvin.plugins.telescope").setup()
		end,
	})

	use({
		"gbprod/yanky.nvim",
		config = function()
			require("tobyvin.plugins.yanky").setup()
		end,
	})

	use({
		"L3MON4D3/LuaSnip",
		requires = {
			"rafamadriz/friendly-snippets",
			"molleweide/LuaSnip-snippets.nvim",
		},
		config = function()
			require("tobyvin.plugins.luasnip").setup()
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		requires = {
			"nvim-treesitter/playground",
			"nvim-treesitter/nvim-treesitter-refactor",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/nvim-treesitter-context",
			"RRethy/nvim-treesitter-textsubjects",
			"JoosepAlviste/nvim-ts-context-commentstring",
			"mfussenegger/nvim-ts-hint-textobject",
		},
		config = function()
			require("tobyvin.plugins.treesitter").setup()
		end,
	})

	use("norcalli/nvim-colorizer.lua")

	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("tobyvin.plugins.indent_blankline").setup()
		end,
	})

	use({
		"lukas-reineke/virt-column.nvim",
		config = function()
			require("virt-column").setup()
		end,
	})

	use({
		"nvim-lualine/lualine.nvim",
		requires = {
			"kyazdani42/nvim-web-devicons",
			"SmiteshP/nvim-navic",
		},
		config = function()
			require("tobyvin.plugins.lualine").setup()
		end,
	})

	use({
		"j-hui/fidget.nvim",
		config = function()
			require("tobyvin.plugins.fidget").setup()
		end,
	})

	use({
		"SmiteshP/nvim-navic",
		requires = "onsails/lspkind-nvim",
		config = function()
			require("tobyvin.plugins.lualine").setup()
		end,
	})

	use({
		"TimUntersberger/neogit",
		requires = { "sindrets/diffview.nvim" },
		config = function()
			require("tobyvin.plugins.neogit").setup()
		end,
	})

	use({
		"sindrets/diffview.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			require("tobyvin.plugins.diffview").setup()
		end,
	})

	use({
		"akinsho/git-conflict.nvim",
		config = function()
			require("tobyvin.plugins.git-conflict").setup()
		end,
	})

	use({
		"lewis6991/gitsigns.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("tobyvin.plugins.gitsigns").setup()
		end,
	})

	if vim.fn.executable("gh") == 1 then
		use("pwntester/octo.nvim")
	end

	use({
		"jiaoshijie/undotree",
		requires = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("tobyvin.plugins.undotree").setup()
		end,
	})

	use({
		"folke/which-key.nvim",
		config = function()
			require("tobyvin.plugins.which-key").setup()
		end,
	})

	use({
		"mfussenegger/nvim-dap",
		requires = {
			"leoluz/nvim-dap-go",
		},
		config = function()
			require("tobyvin.plugins.dap").setup()
		end,
	})

	use({
		"jayp0521/mason-nvim-dap.nvim",
		after = { "mason.nvim", "nvim-dap" },
		requires = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("tobyvin.plugins.mason-nvim-dap").setup()
		end,
	})

	use({
		"theHamsta/nvim-dap-virtual-text",
		requires = {
			"mfussenegger/nvim-dap",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("tobyvin.plugins.nvim-dap-virtual-text").setup()
		end,
	})

	use({
		"rcarriga/nvim-dap-ui",
		requires = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("tobyvin.plugins.dapui").setup()
		end,
	})

	use("ellisonleao/glow.nvim")
	use("ThePrimeagen/harpoon")
	use("b0o/SchemaStore.nvim")

	use({
		"nacro90/numb.nvim",
		config = function()
			require("numb").setup()
		end,
	})

	use({
		"ur4ltz/surround.nvim",
		config = function()
			require("tobyvin.plugins.surround").setup()
		end,
	})

	use({
		"numToStr/Comment.nvim",
		config = function()
			require("tobyvin.plugins.comment").setup()
		end,
	})

	use({
		"tiagovla/scope.nvim",
		config = function()
			require("scope").setup()
		end,
	})
end

M.setup = function()
	local packer_bootstrap = M.ensure_packer()
	local status_ok, packer = pcall(require, "packer")
	if not status_ok then
		vim.notify("Failed to load module 'packer'", vim.log.levels.ERROR)
		return
	end

	utils.keymap.group("n", "<leader>p", { desc = "Packer" })
	vim.keymap.set("n", "<leader>pc", packer.compile, { desc = "Compile" })
	vim.keymap.set("n", "<leader>pC", packer.clean, { desc = "Clean" })
	vim.keymap.set("n", "<leader>pi", packer.install, { desc = "Install" })
	vim.keymap.set("n", "<leader>pp", packer.profile_output, { desc = "Profile" })
	vim.keymap.set("n", "<leader>ps", packer.sync, { desc = "Sync" })
	vim.keymap.set("n", "<leader>pu", packer.update, { desc = "Update" })

	return packer.startup({
		function(...)
			M.plugins(...)
			if packer_bootstrap then
				packer.sync()
			end
		end,
		config = {
			display = {
				open_fn = function()
					return require("packer.util").float({ border = "rounded" })
				end,
			},
			autoremove = true,
		},
	})
end

return M
