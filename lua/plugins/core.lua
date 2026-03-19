return {
  "wbthomason/packer.nvim",
  "nvim-lua/plenary.nvim",
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      local ok, devicons = pcall(require, "nvim-web-devicons")
      if ok then
        devicons.setup()
      end
    end,
  },
}
