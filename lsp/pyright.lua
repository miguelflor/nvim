return {
  -- Can by dafault go to the pyright in the environment
  cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/pyright-langserver"), "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    ".git",
  },
}
