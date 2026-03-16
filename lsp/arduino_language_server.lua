return {
  filetypes = { 'arduino' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local dir = vim.fs.dirname(
      vim.fs.find({ 'sketch.yaml', '*.ino' }, {
        upward = true,
        path = vim.fs.dirname(fname),
      })[1]
    )
    if dir then
      on_dir(dir)
    end
  end,
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
