return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_patterns = { "Cargo.toml", "Cargo.lock", ".git" },
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = "clippy"
      },
      diagnostics = {
        enable = true
      },
      lens = {
        debug = { enable = true },
        enable = true,
        implementations = { enable = true },
        references = {
          adt = { enable = true },
          enumVariant = { enable = true },
          method = { enable = true },
          trait = { enable = true },
        },
        run = { enable = true },
        updateTest = { enable = true },
      },
    },
  },
}
