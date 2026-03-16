return function(use)
  use "MunifTanjim/nui.nvim"
  use({
    "rose-pine/neovim",
    as = "rose-pine",
    config = function()
      require("config.ui").colors()
    end,
  })

  use({
    "goolord/alpha-nvim",
    config = function()
      require("config.ui").dashboard()
    end,
  })

  use({
    "nvim-lualine/lualine.nvim",
    config = function()
      require("config.ui").statusline()
    end,
  })

  use({
    "nvim-tree/nvim-tree.lua",
    requires = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.ui").explorer()
    end,
  })

  use({
    "OXY2DEV/markview.nvim",
    config = function()
      require("config.notes").markview()
    end,
  })

  -- use({
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   ft = { "markdown", "rmd" },
  --   config = function()
  --     require("config.notes").render_markdown()
  --   end,
  -- })
  --
  use 'rcarriga/nvim-notify'

end
