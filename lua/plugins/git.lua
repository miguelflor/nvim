return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("config.git").gitsigns()
    end,
  },
  {
    "echasnovski/mini.diff",
    branch = "stable",
    config = function()
      require("config.git").mini_diff()
    end,
  },
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
}
