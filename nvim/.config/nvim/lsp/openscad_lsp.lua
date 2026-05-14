---@type vim.lsp.Config
return {
  cmd = { 'openscad-lsp', '--stdio' },
  filetypes = { 'openscad' },
  root_markers = { '.git' },
}
