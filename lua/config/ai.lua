local M = {}

M.opencode_setup = function()
  vim.g.opencode_opts = {
    server = {
      start = function()
        require("snacks.terminal").open("opencode --port", {
          win = {
            relative = "editor",
            width = 0.8,
            height = 0.8,
            border = "rounded",
            style = "minimal",
          },
        })
      end,
      stop = function()
        require("snacks.terminal").close()
      end,
      toggle = function()
        require("snacks.terminal").toggle("opencode --port", {
          win = {
            relative = "editor",
            width = 0.8,
            height = 0.8,
            border = "rounded",
            style = "minimal",
          },
        })
      end,
    },
  }

  vim.o.autoread = true

  -- vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end,
  --   { desc = "Ask opencode…" })
  -- vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,
  --   { desc = "Execute opencode action…" })
  -- vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end, { desc = "Toggle opencode" })
  --
  -- vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
  --   { desc = "Add range to opencode", expr = true })
  vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
    { desc = "Add line to opencode", expr = true })

  vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,
    { desc = "Scroll opencode up" })
  vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end,
    { desc = "Scroll opencode down" })

  -- vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
  -- vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
end

return M
