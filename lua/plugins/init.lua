local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
  vim.cmd("packadd packer.nvim")
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    autocmd BufWritePost lua/plugins/*.lua source <afile> | PackerCompile
  augroup END
]])

local plugin_modules = {
  require("plugins.core"),
  require("plugins.ui"),
  require("plugins.navigation"),
  require("plugins.editor"),
  require("plugins.git"),
  require("plugins.ai"),
  require("plugins.lsp"),
}

return require("packer").startup(function(use)
  for _, register in ipairs(plugin_modules) do
    register(use)
  end
end)
