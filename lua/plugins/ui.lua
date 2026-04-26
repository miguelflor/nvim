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
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   config = function()
  --     require("config.ui").explorer()
  --   end,
  -- },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    -- dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.

    config = function()
      require("config.ui").oil()
    end,
    lazy = false,
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
        open_mapping = [[<c-\>]],
        size = function(term)
          if term.direction == "horizontal" then
            return vim.o.lines
          elseif term.direction == "vertical" then
            return vim.o.columns
          end
        end,
        direction = "float", -- float gives you full-screen-like feel
        float_opts = {
          border = "curved",
          width = vim.o.columns,
          height = vim.o.lines - 3,
        },
      })
    end
  }
}
