return {
  filetypes = { 'arduino' },
  root_markers = { "sketch.yaml", ".git" }
  ,
  cmd = {
    'arduino-language-server',
  },
  capabilities = {
    textDocument = {
      ---@diagnostic disable-next-line: assign-type-mismatch
      semanticTokens = vim.NIL,
    },
    workspace = {
      ---@diagnostic disable-next-line: assign-type-mismatch
      semanticTokens = vim.NIL,
    },
  },
}
