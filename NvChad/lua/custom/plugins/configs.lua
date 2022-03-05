local M = {}

-- overriding default plugin configs!
M.treesitter = {
   ensure_installed = {
      "lua",
      "vim",
      "html",
      "css",
      "javascript",
      "json",
      "toml",
      "markdown",
      "c",
      "rust",
      "bash",
   },
}

M.nvimtree = {
   git = {
      enable = true,
   },
}

return M