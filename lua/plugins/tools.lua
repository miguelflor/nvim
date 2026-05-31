return {
  {
    "emrearmagan/dockyard.nvim",
    dependencies = {
      "akinsho/toggleterm.nvim",
    },
    cmd = { "Dockyard", "DockyardFloat" },
    lazy = true,
    config = function()
      require("dockyard").setup({})
    end,
  }
}
