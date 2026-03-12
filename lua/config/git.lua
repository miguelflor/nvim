local M = {}

function M.gitsigns()
  local ok, gitsigns = pcall(require, "gitsigns")
  if not ok then
    return
  end

  gitsigns.setup({
    current_line_blame = true,
    on_attach = function(bufnr)
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end
      map("n", "]h", gitsigns.next_hunk, "Next hunk")
      map("n", "[h", gitsigns.prev_hunk, "Prev hunk")
      map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
      map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
      map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")
    end,
  })
end

function M.mini_diff()
  local ok, diff = pcall(require, "mini.diff")
  if not ok then
    return
  end

  diff.setup({
    mappings = {
      apply = "ga",
      reset = "gr",
    },
    options = {
      signs = { add = "▎", change = "▎", delete = "" },
    },
  })
end

return M
