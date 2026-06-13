---@type vim.lsp.Config
return {
  cmd = { "zls" },
  filetypes = { "zig", "zir" },
  root_markers = { "build.zig", ".git" },
  single_file_support = true
}
