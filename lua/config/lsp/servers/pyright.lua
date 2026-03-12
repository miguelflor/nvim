return function(mason_bin)
  return {
    name = "pyright",
    cmd = { mason_bin .. "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_patterns = {
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      ".git",
    },
  }
end
