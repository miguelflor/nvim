return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_patterns = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    ".git",
  },
}
