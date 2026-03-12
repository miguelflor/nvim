return function(mason_bin)
  return {
    name = "lua_ls",
    cmd = { mason_bin .. "lua-language-server" },
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
end
