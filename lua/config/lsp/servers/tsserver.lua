return function(mason_bin)
  return {
    name = "tsserver",
    cmd = { mason_bin .. "typescript-language-server", "--stdio" },
    filetypes = {
      "typescript",
      "typescriptreact",
      "typescript.tsx",
      "javascript",
      "javascriptreact",
    },
    root_patterns = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  }
end
