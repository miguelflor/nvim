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
    init = function()
      -- Must add trailing slash to match nvim-treesitter's health check expectation
      vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site/")
    end,
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
    config = function()
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
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "zathura" -- or "skim" on macOS, "sioyek", etc.
      vim.g.vimtex_compiler_method = "latexmk"
    end
  },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      { "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    ft = "python",
    keys = { { ",v", "<cmd>VenvSelect<cr>" } },
    opts = {
      options = {
        override_notify = false,
      },
      search = {}
    },
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
      require("config.lsp").setup_conform()
    end
  },
  {
    "yuukiflow/Arduino-Nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      -- Load Arduino plugin for .ino files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "arduino",
        callback = function()
          require("Arduino-Nvim")
        end,
      })
    end,
  }
}
