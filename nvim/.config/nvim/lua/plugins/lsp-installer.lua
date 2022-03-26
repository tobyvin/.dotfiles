local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  print("Failed to require nvim-lsp-installer")
end

-- Provide settings first!
lsp_installer.settings {
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    },

    -- Limit for the maximum amount of servers to be installed at the same time. Once this limit is reached, any further
    -- servers that are requested to be installed will be put in a queue.
    max_concurrent_installers = 4
}

---------------------------------------------------
local enhance_server_opts = {
  ["eslintls"] = function(opts)
    opts.settings = {
      format = {
        enable = true,
      },
    }
  end,
  ["gopls"] = function(opts)
    opts.cmd = { 
      "gopls", 
      "serve",
    }
    opts.settings = {
      gopls = {
        staticcheck = true,
        analyses = {
          unusedparams = true,
        },
      },
    }
  end
}


local function make_server_ready(attach)
  lsp_installer.on_server_ready(function(server)
    -- Specify the default options which we'll use to setup all servers
    local opts = {
      on_attach = on_attach,
    }
    if server.name == "rust_analyzer" then
      local rustopts = {
        tools = {
          autoSetHints = true,
          hover_with_actions = false,
          inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
          },
        },
        server = vim.tbl_deep_extend("force", server:get_default_options(), opts, {
          settings = {
            ["rust-analyzer"] = {
              completion = {
                postfix = {
                  enable = false
                }
              },
              checkOnSave = {
                command = "clippy"
              },
            }
          }
        }),
      }
      require("rust-tools").setup(rustopts)
      server:attach_buffers()
    else
      if enhance_server_opts[server.name] then
        -- Enhance the default opts with the server-specific ones
        enhance_server_opts[server.name](opts)
      end
      -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
      server:setup(opts)
    end

    vim.cmd [[ do User LspAttachBuffers ]]
  end)
end
---------------------------------------------------

---------------------------------------------------
local servers = {
  "rust_analyzer",
  "tsserver", -- for javascript
  "jsonls", -- for json
  "texlab", -- for latex
  "ltex",
  "sqlls", -- for sql
  "pylsp", -- for python
  "sumneko_lua", -- for lua
  "gopls", -- for go
  "yamlls",
  "bashls",
  "dockerls"
}

-- setup the LS
require "plugins.lspconfig"
make_server_ready(On_attach) -- LSP mappings

-- install the LS
for _, name in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found then
    if not server:is_installed() then
      print("Installing " .. name)
      server:install()
    end
  end
end