local M = {}

function M.setup()
  local coc_filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" }
  -- Disable blink.cmp for coc filetypes
  vim.api.nvim_create_autocmd("FileType", {
    pattern = coc_filetypes,
    callback = function()
      vim.b.completion = false
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = coc_filetypes,
    callback = function(ev)
      require("config.keymaps").coc(ev.buf)
    end,
  })
end

return M
