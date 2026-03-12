local M = {}

function M.safe_require(mod)
  local ok, pkg = pcall(require, mod)
  if ok then
    return pkg
  end
end

function M.root_dir(bufnr, patterns)
  patterns = patterns or { ".git" }
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then
    path = vim.loop.cwd()
  end
  local dir = vim.fs.dirname(path)
  if not dir then
    return vim.loop.cwd()
  end
  local root = vim.fs.find(patterns, { path = dir, upward = true })[1]
  if root then
    local normalized = vim.fs.dirname(root)
    if normalized and normalized ~= "" then
      return normalized
    end
  end
  return dir
end

function M.join_paths(...)
  local sep = package.config:sub(1, 1)
  return table.concat({ ... }, sep)
end

return M
