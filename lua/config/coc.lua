local M = {}

function M.setup()
  -- Disable blink.cmp for coc filetypes
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    callback = function()
      vim.b.completion = false
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    callback = function(ev)
      require("config.keymaps").coc(ev.buf)
    end,
  })
end

return M
