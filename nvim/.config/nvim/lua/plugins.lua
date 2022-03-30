local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
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
  use 'Mofiqul/vscode.nvim' -- vscode theme

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
    'neovim/nvim-lspconfig', 
    config = [[require('plugins/lspconfig')]] 
  }

  use { 
    "williamboman/nvim-lsp-installer", 
    config = [[require('plugins/lsp-installer')]] 
  }

  use 'nvim-lua/lsp_extensions.nvim'
  use 'simrat39/rust-tools.nvim'
  use 'simrat39/symbols-outline.nvim'

  use { 
    "folke/trouble.nvim", 
    cmd = "TroubleToggle" 
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      { "onsails/lspkind-nvim", config = [[require('plugins/lspkind')]] }, -- vscode-like pictograms for cmp
      'ray-x/lsp_signature.nvim',
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

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'BurntSushi/ripgrep',
      'nvim-telescope/telescope-dap.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      { "nvim-telescope/telescope-frecency.nvim", requires = "tami5/sqlite.lua" },
    },
    config = [[require('plugins/telescope')]],
  }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = [[require('plugins/null-ls')]]
  }

  use {
    "L3MON4D3/LuaSnip",
    requires = "rafamadriz/friendly-snippets",
    config = [[require('plugins/luasnip')]]
  }

  use {
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

  use "tpope/vim-eunuch"

  use {
    "nvim-lualine/lualine.nvim",
    requires = {
      { "kyazdani42/nvim-web-devicons" },
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
    requires = 'nvim-lua/plenary.nvim',
    config = [[require('plugins/gitsigns')]],
  }

  use {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    config = [[require('neogit').setup {disable_commit_confirmation = true, disable_signs = true}]]
  }

  use 'kdheepak/lazygit.nvim'

  use { 
    "f-person/git-blame.nvim", 
    config = [[require('plugins/git-blame')]] 
  }

  use {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    config = [[vim.g.undotree_SetFocusWhenToggle = 1]],
  }

  use { 
    "ThePrimeagen/git-worktree.nvim", 
    config = [[require('plugins/git-worktree')]] 
  }

  use { 
    'ThePrimeagen/refactoring.nvim', 
    opt = true 
  }

  use {
    "ahmedkhalf/project.nvim",
    config = [[require('plugins/project')]] 
  }

  use { 
    "folke/which-key.nvim", 
    config = [[require('plugins/which-key')]] 
  }

  use {
    'mfussenegger/nvim-dap',
    requires = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "Pocco81/DAPInstall.nvim",
    },
    config = [[require('plugins/dap')]],
  }

  use 'rcarriga/nvim-notify'
  use "antoinemadec/FixCursorHold.nvim"
  use "nacro90/numb.nvim"
  use "Shatur/neovim-session-manager"
  use 'ThePrimeagen/harpoon'
  use "b0o/SchemaStore.nvim"
  use 'windwp/nvim-spectre'
  
  use { 
    'goolord/alpha-nvim', 
    config = [[require('plugins/alpha')]] 
  }

  use { 
    "filipdutescu/renamer.nvim", 
    config = [[require('plugins/renamer')]] 
  }

  use { 
    'numToStr/Comment.nvim', 
    config = [[require('Comment').setup()]] 
  }

  use {
    'norcalli/nvim-colorizer.lua',
    ft = {
      'css',
      'javascript',
      'vim',
      'html'
    },
    config = [[require('colorizer').setup {'css', 'javascript', 'vim', 'html'}]],
  }

  use {
    'akinsho/nvim-bufferline.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = [[require('plugins/bufferline')]],
  }

  use "moll/vim-bbye"
  use 'SmiteshP/nvim-gps'

  use {
    "kyazdani42/nvim-tree.lua",
    requires = {
      {
        'yamatsum/nvim-nonicons',
        requires = 'kyazdani42/nvim-web-devicons'
      },
    },
    config = [[require('plugins/nvim-tree')]]
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
