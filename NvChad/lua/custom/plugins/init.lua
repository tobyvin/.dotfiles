return {

    {
      "williamboman/nvim-lsp-installer",
      requires = 'nvim-lspconfig',
      after = 'nvim-lspconfig',
      config = function()
        local lsp_installer = require "nvim-lsp-installer"

        lsp_installer.settings({
          ui = {
            icons = {
              server_installed = "✓",
              server_pending = "➜",
              server_uninstalled = "✗"
            }
          }
        })

        lsp_installer.on_server_ready(function(server)
          local opts = {}

          server:setup(opts)
          vim.cmd [[ do User LspAttachBuffers ]]
        end)
      end,
    },


    { 
      'TimUntersberger/neogit', 
      cmd = 'Neogit', 
      config = function()
        require('neogit').setup { 
          disable_commit_confirmation = true, 
          disable_signs = true 
        }
      end 
    },

    {
      "jose-elias-alvarez/null-ls.nvim",
      after = "nvim-lspconfig",
      config = function()
         require("custom.plugins.null-ls").setup()
      end,

   },


   {
      "nvim-telescope/telescope-frecency.nvim",
      after = "telescope.nvim",
      config = function()
        require("telescope").load_extension("frecency")
      end,
      requires = 'tami5/sqlite.lua',
    },
    
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      after = "telescope.nvim",
      config = function()
        require("telescope").setup {
           extensions = {
            fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = true,  -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
                case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            }
          }
        }
        require("telescope").load_extension("fzf")
      end,
      run = 'make',
   },

  {
      "karb94/neoscroll.nvim",
       opt = true,
       config = function()
          require("neoscroll").setup()
       end,

       -- lazy loading
       setup = function()
         require("core.utils").packer_lazy_load "neoscroll.nvim"
       end,
}
}
