return {
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("config.telescope").setup()
    end,
  },
  {
    "DrKJeff16/project.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("config.project").setup()
    end,
  },
  {
    "rmagatti/auto-session",
    config = function()
      require("config.sessions").setup()
    end,
  },
  {
    "theprimeagen/harpoon",
    config = function()
      require("config.harpoon").setup()
    end,
  },
  {
    dir = vim.fn.expand("~/.config/nvim/lua/cameleer"),
    config = function()
      require("cameleer").setup()
    end,
  },
}
