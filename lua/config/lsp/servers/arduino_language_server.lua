return function(mason_bin)
  return {
    name = "arduino_language_server",
    cmd = {
      mason_bin .. "arduino-language-server",
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
    filetypes = { "arduino" },
    root_patterns = { "*.ino", "sketch.yaml", ".git" },
  }
end
