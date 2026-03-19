return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("config.mason").setup()
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      require("config.lsp").setup_null_ls()
    end,
  },
  "mfussenegger/nvim-dap",
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },
  "jay-babu/mason-nvim-dap.nvim",
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = { "java" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("config.treesitter").setup()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
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
  },
  {
    dir = vim.fn.expand("~/projects/pest.nvim"),
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function ()
      require("pest-vim").setup();
    end
  },
  {
    "mistweaverco/kulala.nvim",
    config = function()
      require("kulala").setup({
        global_keymaps = false,
        global_keymaps_prefix = "<leader>R",
        kulala_keymaps_prefix = "",
      })
      require("config.keymaps").kulala()
    end,
  },
  {
    "folke/lazydev.nvim",
    dependencies = { "Bilal2453/luvit-meta" },
    config = function()
      require("lazydev").setup({
        library = {
          { path = "luvit-meta/library", words = { "vim%.uv" } },
        },
      })
    end,
  },
}
