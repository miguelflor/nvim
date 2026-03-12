return function(use)
  use({
    "numToStr/Comment.nvim",
    event = "BufReadPre",
    config = function()
      require("config.editor").comment()
    end,
  })

  use({
    "kylechui/nvim-surround",
    event = "BufReadPost",
    config = function()
      require("config.editor").surround()
    end,
  })

  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("config.editor").colorizer()
    end,
  })

  use({
    "folke/todo-comments.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.editor").todo()
    end,
  })

  use({
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("config.editor").autopairs()
    end,
  })

  use({
    "windwp/nvim-ts-autotag",
    after = "nvim-treesitter",
    config = function()
      require("config.editor").autotag()
    end,
  })

  use({
    "folke/which-key.nvim",
    config = function()
      require("config.editor").whichkey()
    end,
  })

  use({
    "Pocco81/auto-save.nvim",
    config = function()
      require("config.editor").autosave()
    end,
  })

  use({
    "gbprod/cutlass.nvim",
    config = function()
      require("config.editor").cutlass()
    end,
  })

  use({
    "karb94/neoscroll.nvim",
    config = function()
      require("config.editor").neoscroll()
    end,
  })

  use("mbbill/undotree")
  use("mg979/vim-visual-multi")
end
