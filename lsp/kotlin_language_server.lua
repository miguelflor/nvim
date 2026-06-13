---@type vim.lsp.Config
return {
  cmd = { 'kotlin-language-server' },
  filetypes = { 'kotlin' },
  root_markers = { "pom.xml" },
}
