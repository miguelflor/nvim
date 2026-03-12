return {
  cmd = { "arduino-language-server" },
  capabilities = {
    textDocument = {
      semanticTokens = vim.NIL,
    },
    workspace = {
      semanticTokens = vim.NIL,
    },
  },
  filetypes = { "arduino" },
  root_patterns = { "*.ino", "sketch.yaml", ".git" },
}
