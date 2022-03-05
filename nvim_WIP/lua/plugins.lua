local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  
  -- plugins

  -- Packer
  use '~/projects/personal/packer.nvim'

  use 'lewis6991/impatient.nvim'

  -- Async building & commands
  use { 'tpope/vim-dispatch', cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } }

    -- Search
  use {
    {
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        'telescope-frecency.nvim',
        'telescope-fzf-native.nvim',
      },
      wants = {
        'popup.nvim',
        'plenary.nvim',
        'telescope-frecency.nvim',
        'telescope-fzf-native.nvim',
      },
      setup = function() require('config.telescope_setup') end,
      config = function() require('config.telescope') end,
      cmd = 'Telescope',
      module = 'telescope',
    },
    {
      'nvim-telescope/telescope-frecency.nvim',
      after = 'telescope.nvim',
      requires = 'tami5/sqlite.lua',
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make',
    },
  }

    -- Undo tree
  use {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    config = function() vim.g.undotree_SetFocusWhenToggle = 1 end,
  }

  -- Git
  use {
    { 'tpope/vim-fugitive', cmd = { 'Git', 'Gstatus', 'Gblame', 'Gpush', 'Gpull' }, disable = true },
    {
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
    },
    { 'TimUntersberger/neogit', 
      cmd = 'Neogit', 
      config = function() require('neogit').setup {disable_commit_confirmation = true, disable_signs = true} end
  },
  }

  -- linting
  use {
    {
      'neovim/nvim-lspconfig',
      config = function() require('config.lspconfig') end,
    },
    {
      "williamboman/nvim-lsp-installer",
      requires = 'nvim-lspconfig',
      after = 'nvim-lspconfig',
      config = function() require('config.lspinstaller') end,
    },
    'folke/trouble.nvim',
    'ray-x/lsp_signature.nvim',
    'kosayoda/nvim-lightbulb',
  }

    -- Completion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'L3MON4D3/LuaSnip',
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      { 'onsails/lspkind-nvim', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
      { 'nvim-lua/lsp_extensions.nvim', after = 'nvim-cmp' },
    },
    config = function() require('config.cmp') end,
    event = 'InsertEnter *',
  }

  use({
      "folke/which-key.nvim",
      config = function() require("which-key").setup({}) end,
  })

  -- Highlights
  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      'nvim-treesitter/nvim-treesitter-refactor',
      'RRethy/nvim-treesitter-textsubjects',
    },
    run = ':TSUpdate',
  }


  -- Debugger
  use {
    {
      'Pocco81/DAPInstall.nvim',
      config = function() require("dap-install").config("chrome", {}) end,
    },
    {
      'mfussenegger/nvim-dap',
      setup = function() require('config.dap_setup') end,
      after = 'dap-install',
      config = function() require('config.dap') end,
      module = 'dap',
    },
    {
      'puremourning/vimspector',
      requires = 'nvim-dap',
      after = 'nvim-dap',
      setup = function() vim.g.vimspector_enable_mappings = 'HUMAN' end,
    },
    {
      'rcarriga/nvim-dap-ui',
      requires = 'nvim-dap',
      disable = true,
      after = 'nvim-dap',
      config = function() require('dapui').setup() end,
    },
  }
  
  -- Profiling
  use { 'dstein64/vim-startuptime', cmd = 'StartupTime', config = function() vim.g.startuptime_tries = 10 end }

  -- Refactoring
  use { 'ThePrimeagen/refactoring.nvim', opt = true }

  -- Highlight colors
  use {
    'norcalli/nvim-colorizer.lua',
    ft = { 'css', 'javascript', 'vim', 'html' },
    config = function() require('colorizer').setup {'css', 'javascript', 'vim', 'html'} end,
  }

    -- Buffer management
  use {
    'akinsho/nvim-bufferline.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function() require('config.bufferline') end,
    event = 'User ActuallyEditing',
  }  
  
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

