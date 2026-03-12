local M = {}

function M.setup()
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    return
  end

  local actions = require("telescope.actions")
  local history_path = vim.fn.stdpath("data") .. "/telescope_history"

  telescope.setup({
    defaults = {
      prompt_prefix = "   ",
      selection_caret = " ",
      path_display = { "truncate" },
      file_ignore_patterns = { "node_modules", ".git/" },
      history = {
        path = history_path,
        limit = 500,
      },
      mappings = {
        i = {
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        },
      },
    },
    pickers = {
      find_files = {
        hidden = true,
      },
    },
  })

  pcall(telescope.load_extension, "harpoon")
end

return M
