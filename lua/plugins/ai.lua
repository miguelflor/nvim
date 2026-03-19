return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      require("config.ai").codecompanion()
    end,
  },
}
