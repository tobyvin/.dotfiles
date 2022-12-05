local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()
local packer = require("tobyvin.plugins.packer")

return packer.startup({
	function(use)
		use("wbthomason/packer.nvim")

		use("lewis6991/impatient.nvim")

		use({
			"goolord/alpha-nvim",
			requires = { "kyazdani42/nvim-web-devicons" },
			config = function()
				require("tobyvin.plugins.alpha")
			end,
		})

		use({
			"rcarriga/nvim-notify",
			event = "VimEnter",
			config = function()
				require("tobyvin.plugins.notify")
			end,
		})

		use({
			"stevearc/dressing.nvim",
			config = function()
				require("tobyvin.plugins.dressing")
			end,
		})

		use({
			"ellisonleao/gruvbox.nvim",
			config = function()
				require("tobyvin.plugins.gruvbox")
			end,
		})

		use({
			"folke/tokyonight.nvim",
			config = function()
				require("tobyvin.plugins.tokyonight")
			end,
		})

		use({
			"Shatur/neovim-session-manager",
			config = function()
				require("tobyvin.plugins.session_manager")
			end,
		})

		use({
			"williamboman/mason.nvim",
			requires = {
				"RubixDev/mason-update-all",
				"williamboman/mason-lspconfig.nvim",
				"jayp0521/mason-null-ls.nvim",
				"jayp0521/mason-nvim-dap.nvim",
			},
			config = function()
				require("tobyvin.plugins.mason")
			end,
		})

		use({
			"jose-elias-alvarez/null-ls.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
			},
			config = function()
				require("tobyvin.plugins.null-ls")
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
				require("tobyvin.plugins.crates")
			end,
		})

		use({
			"hrsh7th/nvim-cmp",
			requires = {
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-nvim-lsp-document-symbol",
				"hrsh7th/cmp-nvim-lsp-signature-help",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-cmdline",
				"petertriho/cmp-git",
				"Dosx001/cmp-commit",
				"davidsierradz/cmp-conventionalcommits",
				"rcarriga/cmp-dap",
				"ray-x/lsp_signature.nvim",
				"saadparwaiz1/cmp_luasnip",
				"saecki/crates.nvim",
				"kdheepak/cmp-latex-symbols",
			},
			config = function()
				require("tobyvin.plugins.cmp")
			end,
		})

		use({
			"petertriho/cmp-git",
			requires = "nvim-lua/plenary.nvim",
			config = function()
				require("tobyvin.plugins.cmp-git")
			end,
		})

		use({
			"David-Kunz/cmp-npm",
			event = { "BufRead package.json" },
			requires = {
				"nvim-lua/plenary.nvim",
			},
			config = function()
				require("tobyvin.plugins.cmp-npm")
			end,
		})

		use({
			"onsails/lspkind-nvim",
			config = function()
				require("tobyvin.plugins.lspkind")
			end,
		})

		use({
			"folke/neodev.nvim",
			config = function()
				require("tobyvin.plugins.neodev")
			end,
		})

		use({
			"simrat39/rust-tools.nvim",
			requires = {
				"neovim/nvim-lspconfig",
				"nvim-lua/plenary.nvim",
			},
			config = function()
				require("tobyvin.plugins.rust-tools")
			end,
		})

		use({
			"neovim/nvim-lspconfig",
			after = {
				"neodev.nvim",
				"cmp-nvim-lsp",
			},
			config = function()
				require("tobyvin.plugins.lspconfig")
			end,
		})

		use({
			"kevinhwang91/nvim-bqf",
			requires = {
				"nvim-treesitter/nvim-treesitter",
				"junegunn/fzf",
			},
			ft = "qf",
			config = function()
				require("tobyvin.plugins.nvim-bqf")
			end,
		})

		use({
			"nvim-telescope/telescope.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
				"BurntSushi/ripgrep",
				{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
				"nvim-telescope/telescope-file-browser.nvim",
				"nvim-telescope/telescope-live-grep-args.nvim",
				"nvim-telescope/telescope-dap.nvim",
			},
			config = function()
				require("tobyvin.plugins.telescope")
			end,
		})

		use({
			"gbprod/yanky.nvim",
			config = function()
				require("tobyvin.plugins.yanky")
			end,
		})

		use({
			"L3MON4D3/LuaSnip",
			requires = {
				"rafamadriz/friendly-snippets",
				"molleweide/LuaSnip-snippets.nvim",
			},
			config = function()
				require("tobyvin.plugins.luasnip")
			end,
		})

		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			requires = {
				"nvim-treesitter/playground",
				"nvim-treesitter/nvim-treesitter-textobjects",
				"nvim-treesitter/nvim-treesitter-context",
				"JoosepAlviste/nvim-ts-context-commentstring",
				"mfussenegger/nvim-ts-hint-textobject",
			},
			config = function()
				require("tobyvin.plugins.treesitter")
			end,
		})

		use("norcalli/nvim-colorizer.lua")

		use({
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("tobyvin.plugins.indent_blankline")
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
				require("tobyvin.plugins.lualine")
			end,
		})

		use({
			"j-hui/fidget.nvim",
			config = function()
				require("tobyvin.plugins.fidget")
			end,
		})

		use({
			"SmiteshP/nvim-navic",
			requires = "onsails/lspkind-nvim",
			config = function()
				require("tobyvin.plugins.nvim-navic")
			end,
		})

		use({
			"TimUntersberger/neogit",
			requires = { "sindrets/diffview.nvim" },
			config = function()
				require("tobyvin.plugins.neogit")
			end,
		})

		use({
			"sindrets/diffview.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
				"kyazdani42/nvim-web-devicons",
			},
			config = function()
				require("tobyvin.plugins.diffview")
			end,
		})

		use({
			"akinsho/git-conflict.nvim",
			config = function()
				require("tobyvin.plugins.git-conflict")
			end,
		})

		use({
			"lewis6991/gitsigns.nvim",
			requires = "nvim-lua/plenary.nvim",
			config = function()
				require("tobyvin.plugins.gitsigns")
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
				require("tobyvin.plugins.undotree")
			end,
		})

		use({
			"mfussenegger/nvim-dap",
			requires = {
				"nvim-telescope/telescope-dap.nvim",
				"mfussenegger/nvim-dap-python",
				"leoluz/nvim-dap-go",
			},
			config = function()
				require("tobyvin.plugins.dap")
			end,
		})

		use({
			"theHamsta/nvim-dap-virtual-text",
			requires = {
				"mfussenegger/nvim-dap",
				"nvim-treesitter/nvim-treesitter",
			},
			config = function()
				require("tobyvin.plugins.nvim-dap-virtual-text")
			end,
		})

		use({
			"ur4ltz/surround.nvim",
			config = function()
				require("tobyvin.plugins.surround")
			end,
		})

		use({
			"numToStr/Comment.nvim",
			config = function()
				require("tobyvin.plugins.comment")
			end,
		})

		use("ThePrimeagen/harpoon")

		use("b0o/SchemaStore.nvim")

		use({
			"nacro90/numb.nvim",
			config = function()
				require("numb").setup()
			end,
		})

		use({
			"tiagovla/scope.nvim",
			config = function()
				require("scope").setup()
			end,
		})

		if packer_bootstrap then
			require("packer").sync()
		end
	end,
})
