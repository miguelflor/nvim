local group = vim.api.nvim_create_augroup("UserAutoCmds", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

vim.api.nvim_create_user_command("NullLsToggle", function()
  local null_ls = require("null-ls")
  if null_ls.is_registered("formatting") then
    null_ls.disable({})
  else
    null_ls.enable({})
  end
end, {})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
  group = group,
  command = "checktime",
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = group,
  command = "tabdo wincmd =",
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "*",
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
