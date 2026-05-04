return {
  filetypes = { 'arduino' },
  -- arduino_config is specific to the library of Arduino-Nvim
  root_markers = { ".arduino_config.lua", "sketch.yaml", ".git" }
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
