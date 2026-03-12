return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "javascript",
    "javascriptreact",
  },
  root_patterns = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
}
