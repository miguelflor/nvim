return function(use)
  use({
    "nvim-telescope/telescope.nvim",
    config = function()
      require("config.telescope").setup()
    end,
  })

  use({
    "DrKJeff16/project.nvim",
    requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"},
    config = function()
      require("config.project").setup()
    end,
  })

  use({
    "rmagatti/auto-session",
    config = function()
      require("config.sessions").setup()
    end,
  })

  use({
    "theprimeagen/harpoon",
    config = function()
      require("config.harpoon").setup()
    end,
  })

  use({
    "~/.config/nvim/lua/cameleer",
    config = function()
      require("cameleer").setup()
    end,
  })
end
