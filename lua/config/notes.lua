local M = {}

function M.markview()
  local ok, markview = pcall(require, "markview")
  if not ok then
    return
  end

  markview.setup({
    modes = { "preview", "outline" },
  })
end

function M.render_markdown()
  local ok, render = pcall(require, "render-markdown")
  if not ok then
    return
  end

  render.setup({
    filetypes = { "markdown", "rmd" },
    heading = { enabled = true },
  })
end

return M
