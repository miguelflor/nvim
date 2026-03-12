local M = {}

function M.comment()
  local ok, comment = pcall(require, "Comment")
  if not ok then
    return
  end
  comment.setup({})
end

function M.surround()
  local ok, surround = pcall(require, "nvim-surround")
  if not ok then
    return
  end
  surround.setup({})
end

function M.autopairs()
  local ok, autopairs = pcall(require, "nvim-autopairs")
  if not ok then
    return
  end
  autopairs.setup({
    check_ts = true,
    disable_filetype = { "TelescopePrompt" },
  })
end

function M.autotag()
  local ok, autotag = pcall(require, "nvim-ts-autotag")
  if not ok then
    return
  end
  autotag.setup({})
end

function M.colorizer()
  local ok, colorizer = pcall(require, "colorizer")
  if not ok then
    return
  end
  colorizer.setup({ "*" }, { mode = "foreground" })
end

function M.todo()
  local ok, todo = pcall(require, "todo-comments")
  if not ok then
    return
  end
  todo.setup({
    highlight = {
      keyword = "bg",
    },
    search = {
      command = "rg",
    },
  })
end

function M.neoscroll()
  local ok, neoscroll = pcall(require, "neoscroll")
  if not ok then
    return
  end
  neoscroll.setup({})
end

function M.cutlass()
  local ok, cutlass = pcall(require, "cutlass")
  if not ok then
    return
  end
  cutlass.setup({
    cut_key = "x",
    override_del = true,
  })
end

function M.autosave()
  local ok, autosave = pcall(require, "auto-save")
  if not ok then
    return
  end

  autosave.setup({
    debounce_delay = 1000,
    execution_message = {
      message = function()
        return ("AutoSave @ %s"):format(os.date("%H:%M:%S"))
      end,
    },
    condition = function(buf)
      if not vim.api.nvim_buf_is_valid(buf) then
        return false
      end
      local ft = vim.bo[buf].filetype
      if ft == "gitcommit" then
        return false
      end
      return vim.bo[buf].modifiable
    end,
  })
end

function M.whichkey()
  local ok, whichkey = pcall(require, "which-key")
  if not ok then
    return
  end

  whichkey.add({
    { "<leader>f", group = "[F]ind" },
    { "<leader>h", group = "[H]arpoon" },
    { "<leader>q", group = "[Q]uick session" },
  })

  whichkey.setup({
    win = {
      border = "rounded",
    },
  })
end

return M
