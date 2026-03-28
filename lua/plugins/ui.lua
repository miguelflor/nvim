return {
  "MunifTanjim/nui.nvim",
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("config.ui").colors()
    end,
  },
  {
    "goolord/alpha-nvim",
    config = function()
      require("config.ui").dashboard()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("config.ui").statusline()
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.ui").explorer()
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    config = function()
      require("config.notes").markview()
    end,
  },
  "rcarriga/nvim-notify",
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 50,
        open_mapping = [[<c-\>]],
        direction = 'vertical',
        shade_terminals = true,
      })
    end
  }
}
