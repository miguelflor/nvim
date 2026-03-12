local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

local modules = {
  "config.lsp.servers.lua_ls",
  "config.lsp.servers.docker_language_server",
  "config.lsp.servers.pest_ls",
  "config.lsp.servers.rust_analyser",
  "config.lsp.servers.tsserver",
  "config.lsp.servers.tailwind",
  "config.lsp.servers.cssls",
  "config.lsp.servers.clangd",
  "config.lsp.servers.pyright",
  "config.lsp.servers.eslint",
  "config.lsp.servers.flux",
  "config.lsp.servers.texlab",
  "config.lsp.servers.ocaml",
  "config.lsp.servers.arduino_language_server"
}

local servers = {}
for _, module in ipairs(modules) do
  local builder = require(module)
  local config = builder(mason_bin)
  servers[config.name] = config
end

return servers
