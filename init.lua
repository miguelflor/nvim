require("config.options")

local keymaps = require("config.keymaps")
keymaps.setup()

require("config.autocmds")
require("plugins")
require("custom")

local ok, lsp = pcall(require, "config.lsp")
if ok then
  lsp.setup()
end
