local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use) 
  -- My plugins here

  -- Have packer manage itself
  use "wbthomason/packer.nvim"

  use {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    config = [[vim.g.startuptime_tries = 3]]
  }

  use 'lewis6991/impatient.nvim'

  use 'andweeb/presence.nvim'

  use 'Iron-E/nvim-cartographer'

  use 'Mofiqul/vscode.nvim'

  use {
    'tpope/vim-dispatch',
    cmd = {
      'Dispatch',
      'Make',
      'Focus',
      'Start'
    }
  }

  use {
    -- A collection of common configurations for Neovim's built-in language server client
    'neovim/nvim-lspconfig',
    config = [[require('plugins/lspconfig')]],
  }

  use {
    "williamboman/nvim-lsp-installer",
    config = [[require('plugins/lsp-installer')]],
  }

  use 'nvim-lua/lsp_extensions.nvim'
  use 'simrat39/rust-tools.nvim'
  use 'folke/trouble.nvim'
  use 'ray-x/lsp_signature.nvim'
  use 'simrat39/symbols-outline.nvim'
  use 'kosayoda/nvim-lightbulb'

  use {
    -- vscode-like pictograms for neovim lsp completion items Topics
    "onsails/lspkind-nvim",
    config = [[require('plugins/lspkind')]]
  }

  use {
      -- A completion plugin for neovim coded in Lua.
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp', -- nvim-cmp source for neovim builtin LSP client
      'hrsh7th/cmp-nvim-lua', -- nvim-cmp source for nvim lua
      'hrsh7th/cmp-buffer', -- nvim-cmp source for buffer words.
      'hrsh7th/cmp-path', -- nvim-cmp source for filesystem paths.
      'hrsh7th/cmp-calc', -- nvim-cmp source for math calculation.
      'saadparwaiz1/cmp_luasnip', -- luasnip completion source for nvim-cmp
      'hrsh7th/cmp-nvim-lsp-signature-help', -- luasnip completion source for lsp_signature
    },
    config = [[require('plugins/cmp')]],
  }

  use { 'nvim-telescope/telescope-dap.nvim' }

  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
  }


  use {
    "nvim-telescope/telescope-frecency.nvim",
    requires = {
      "tami5/sqlite.lua"
    }
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'BurntSushi/ripgrep',
    },
    config = [[require('plugins/telescope')]],
  }

  use {
    -- Snippet Engine for Neovim written in Lua.
    "L3MON4D3/LuaSnip",
    requires = {
      "rafamadriz/friendly-snippets" -- Snippets collection
    },
    config = [[require('plugins/luasnip')]]
  }

  use {
    -- Nvim Treesitter configurations and abstraction layer
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      'nvim-treesitter/nvim-treesitter-refactor',
      'RRethy/nvim-treesitter-textsubjects',
    },
    config = [[require('plugins/treesitter')]]
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    config = [[require('plugins/blankline')]]
  }

  use {
    "tpope/vim-eunuch"
  }

  use {
    "nvim-lualine/lualine.nvim",
    requires = {
      {
        "kyazdani42/nvim-web-devicons",
        opt = true
      },
    },
    config = [[require('plugins/lualine')]]
  }

  use {
    'tpope/vim-fugitive',
    cmd = {
      'Git',
      'Gstatus',
      'Gblame',
      'Gpush',
      'Gpull'
    },
    disable = true
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  }

  use {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    config = [[require('neogit').setup {disable_commit_confirmation = true, disable_signs = true}]]
  }
  use 'kdheepak/lazygit.nvim'

  use {
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = [[require('plugins/nvim-tree')]]
  }

  use {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    config = [[vim.g.undotree_SetFocusWhenToggle = 1]],
  }

  use {
      "folke/which-key.nvim",
      config = [[require("which-key").setup({})]],
  }

  use {
    'Pocco81/DAPInstall.nvim',
    config = [[require("dap-install").config("chrome", {})]],
  }

  use {
    'mfussenegger/nvim-dap',
    config = [[require('plugins/dap')]],
    module = 'dap',
  }

  use {
    'puremourning/vimspector',
    requires = 'nvim-dap',
    after = 'nvim-dap',
    setup = [[vim.g.vimspector_enable_mappings = 'HUMAN']],
  }

  use {
    'rcarriga/nvim-dap-ui',
    requires = 'nvim-dap',
    disable = true,
    after = 'nvim-dap',
    config = [[require('dapui').setup()]],
  }

  use {
    "ThePrimeagen/git-worktree.nvim",
    config = [[require('plugins/git-worktree')]]
  }

  use {
    'ThePrimeagen/refactoring.nvim',
    opt = true
    -- Can't get to work...
    -- config = [[require('telescope').load_extension('refactoring')]],
  }

  use {
    -- Highlight colors
    'norcalli/nvim-colorizer.lua',
    ft = {
      'css',
      'javascript',
      'vim',
      'html'
    },
    config = [[require('colorizer').setup {'css', 'javascript', 'vim', 'html'}]],
  }

    -- Buffer management
  use {
    'akinsho/nvim-bufferline.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = [[require('plugins/bufferline')]],
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
