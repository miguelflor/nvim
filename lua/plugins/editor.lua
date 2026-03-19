return {
  {
    "numToStr/Comment.nvim",
    event = "BufReadPre",
    config = function()
      require("config.editor").comment()
    end,
  },
  {
    "kylechui/nvim-surround",
    event = "BufReadPost",
    config = function()
      require("config.editor").surround()
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("config.editor").colorizer()
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.editor").todo()
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("config.editor").autopairs()
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("config.editor").autotag()
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      require("config.editor").whichkey()
    end,
  },
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("config.editor").autosave()
    end,
  },
  {
    "gbprod/cutlass.nvim",
    config = function()
      require("config.editor").cutlass()
    end,
  },
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("config.editor").neoscroll()
    end,
  },
  "mbbill/undotree",
  "mg979/vim-visual-multi",
  {
    "azratul/live-share.nvim",
    dependencies = { "jbyuki/instant.nvim" },
    config = function()
      vim.g.instant_username = "your-username"
      require("live-share").setup({
        -- Add your configuration here
      })
    end,
  },
}
