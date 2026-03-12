return function(use)
  use({
    "olimorris/codecompanion.nvim",
    requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      require("config.ai").codecompanion()
    end,
  })
end
