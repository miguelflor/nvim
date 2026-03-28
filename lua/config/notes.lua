local M = {}

function M.markview()
  local ok, markview = pcall(require, "markview")
  if not ok then
    return
  end

  markview.setup({
    modes = { "preview", "outline" },
    filetypes = { "markdown", "quarto", "rmd", "copilot-chat" },
    code_blocks = {
      enable = true,
      style = "language",   -- or "full" if you want the background colored
      hl = "CursorLine",    -- Uses your theme's line highlight color for the block
    },
    buf_ignore = {}
  })
end

return M
