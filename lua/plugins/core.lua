return function(use)
  use("wbthomason/packer.nvim")

  use("nvim-lua/plenary.nvim")

  use({
    "nvim-tree/nvim-web-devicons",
    config = function()
      local ok, devicons = pcall(require, "nvim-web-devicons")
      if ok then
        devicons.setup()
      end
    end,
  })

end
