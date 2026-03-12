return function(mason_bin)
  return {
    name = "cssls",
    cmd = { mason_bin .. "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    root_patterns = { "package.json", ".git" },
  }
end
