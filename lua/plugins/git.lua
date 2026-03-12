return function(use)
  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("config.git").gitsigns()
    end,
  })

  use({
    "echasnovski/mini.diff",
    branch = "stable",
    config = function()
      require("config.git").mini_diff()
    end,
  })

  use("tpope/vim-fugitive")
  use 'tpope/vim-rhubarb'

end
