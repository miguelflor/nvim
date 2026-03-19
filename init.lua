vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/site")
require("config.options")

local keymaps = require("config.keymaps")
keymaps.setup()

require("config.autocmds")
require("plugins")
require("custom")
require("config.dap").setup()

local ok, lsp = pcall(require, "config.lsp")
if ok then
  lsp.setup()
else
  vim.notify("LSP config error: " .. lsp, vim.log.levels.ERROR)
end
