return function(use)
  use({
    "williamboman/mason.nvim",
    config = function()
      require("config.mason").setup()
    end,
  })

  use({
    "nvimtools/none-ls.nvim",
    config = function()
      require("config.lsp").setup_null_ls()
    end,
  })

  use({
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("config.treesitter").setup()
    end,
  })

  use("nvim-treesitter/playground")

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("config.cmp").setup()
    end,
  })

  use({
    '~/projects/pest.nvim',
    requires = {
      "nvim-treesitter/nvim-treesitter"
    },
    config = function()
      require("pest-vim").setup()
    end

  })

  use 'mfussenegger/nvim-dap'
  use "jay-babu/mason-nvim-dap.nvim"
end
