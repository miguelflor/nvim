return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_patterns = { ".luarc.json", ".luacheckrc", "stylua.toml", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      completion = { callSnippet = "Replace" },
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}
