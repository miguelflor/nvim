require("config.options")

local keymaps = require("config.keymaps")
keymaps.setup()

require("config.autocmds")
require("plugins")
require("custom")

local ok, lsp = pcall(require, "config.lsp")
if ok then
  lsp.setup()
else 
  vim.notify("LSP config error: " .. lsp, vim.log.levels.ERROR)
end
  
