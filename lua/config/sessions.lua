local M = {}

function M.setup()
  local ok, persistence = pcall(require, "persistence")
  if not ok then
    return
  end

  persistence.setup({
    dir = vim.fn.stdpath("state") .. "/sessions/",
    need = 1,
    branch = true,
  })
end

return M
