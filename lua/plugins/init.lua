local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local lazy_spec = {
  require("plugins.core"),
  require("plugins.ui"),
  require("plugins.navigation"),
  require("plugins.editor"),
  require("plugins.git"),
  require("plugins.ai"),
  require("plugins.lsp"),
}

require("lazy").setup(lazy_spec, {
  change_detection = {
    enabled = true,
    notify = true,
  },
})
