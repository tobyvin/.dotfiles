local utils = require("tobyvin.utils")
local M = {}

M.plugins = function(use)
	use("wbthomason/packer.nvim")

	use({
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
		config = function()
			vim.g.startuptime_tries = 3
		end,
	})

	use("lewis6991/impatient.nvim")

	use({
		"rcarriga/nvim-notify",
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
		"andweeb/presence.nvim",
		config = function()
			require("tobyvin.plugins.presence").setup()
		end,
	})

	-- TODO: implement custom hls using base-16-gruvbox and remove this
	use({
		"eddyekofo94/gruvbox-flat.nvim",
		config = function()
			require("tobyvin.plugins.gruvbox-flat").setup()
		end,
	})

	use({
		"xiyaowong/nvim-transparent",
		config = function()
			require("tobyvin.plugins.transparent").setup()
		end,
	})

	use({
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({
				log_level = "error",
				cwd_change_handling = {
					restore_upcoming_session = true,
				},
			})
		end,
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
			"SmiteshP/nvim-navic",
			"barreiroleo/ltex-extra.nvim",
		},
		config = function()
			require("tobyvin.plugins.lspconfig").setup()
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
		"folke/lua-dev.nvim",
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
		requires = {
			"neovim/nvim-lspconfig",
			"williamboman/nvim-lsp-installer",
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
		"onsails/lspkind-nvim",
		config = function()
			require("tobyvin.plugins.lspkind").setup()
		end,
	})

	use({
		"simrat39/symbols-outline.nvim",
		config = function()
			require("symbols-outline").setup()
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
			"nvim-telescope/telescope-packer.nvim",
			"nvim-telescope/telescope-github.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
			{ "nvim-telescope/telescope-smart-history.nvim", requires = { "tami5/sqlite.lua", module = "sqlite" } },
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

	use({
		"lewis6991/spellsitter.nvim",
		requires = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("tobyvin.plugins.spellsitter").setup()
		end,
	})

	use({
		"drybalka/tree-climber.nvim",
		requires = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("tobyvin.plugins.tree-climber").setup()
		end,
	})

	use({
		"ThePrimeagen/refactoring.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("tobyvin.plugins.refactoring").setup()
		end,
	})

	use({
		"danymat/neogen",
		requires = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("tobyvin.plugins.neogen").setup()
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
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		config = function()
			vim.g.undotree_SetFocusWhenToggle = 1
		end,
	})

	use({
		"ThePrimeagen/git-worktree.nvim",
		config = function()
			require("tobyvin.plugins.git-worktree")
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
			"rcarriga/nvim-dap-ui",
			{ "theHamsta/nvim-dap-virtual-text", requires = "nvim-treesitter/nvim-treesitter" },
			{ "nvim-telescope/telescope-dap.nvim", requires = "nvim-telescope/telescope.nvim" },
			"leoluz/nvim-dap-go",
		},
		config = function()
			require("tobyvin.plugins.dap").setup()
		end,
	})

	use({ "ellisonleao/glow.nvim" })
	use("nacro90/numb.nvim")
	use("ThePrimeagen/harpoon")
	use("b0o/SchemaStore.nvim")

	use({
		"ggandor/leap.nvim",
		config = function()
			require("tobyvin.plugins.leap").setup()
		end,
	})

	use({
		"ur4ltz/surround.nvim",
		config = function()
			require("tobyvin.plugins.surround").setup()
		end,
	})

	use({
		"antoinemadec/FixCursorHold.nvim",
		config = function()
			vim.g.curshold_updatime = 500
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
	---@diagnostic disable-next-line: missing-parameter
	if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
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
		autoremove = true,
		profile = { enable = true },
	})

	local nmap = utils.create_map_group("n", "<leader>p", { desc = "Packer" })
	nmap("c", packer.compile, { desc = "Compile" })
	nmap("C", packer.clean, { desc = "Clean" })
	nmap("i", packer.install, { desc = "Install" })
	nmap("p", packer.profile_output, { desc = "Profile" })
	nmap("s", packer.sync, { desc = "Sync" })
	nmap("u", packer.update, { desc = "Update" })
	nmap("l", M.open_log, { desc = "Log" })

	return packer.startup(M.plugins)
end

return M
