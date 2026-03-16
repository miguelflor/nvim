local M = {}

function M.arduino_runner()
  local notify = require("notify")
  vim.cmd("silent! write")

  local n_id = notify("Arduino: compiling and uploading...", "info", {
    title = "Arduino CLI",
    icon = "󱐋",
    timeout = false,
  })

  vim.system({ "arduino-cli", "compile", "--upload" }, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code == 0 then
        notify(" Successful!", "info", {
          title = "Arduino CLI",
          icon = "",
          replace = n_id,
          timeout = 3000,
        })
      else
        notify("Failed!\n" .. (obj.stderr or ""), "error", {
          title = "Arduino CLI Error",
          icon = "",
          replace = n_id,
          timeout = 3000,
        })
      end
    end)
  end)
end

function M.arduino_monitor()
  local notify = require("notify")

  -- Check if a monitor window is already open and focus it
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.b[buf]._arduino_monitor then
      vim.api.nvim_set_current_win(win)
      notify("Arduino: monitor already running", "warn", {
        title = "Arduino CLI",
        icon = "",
        timeout = 2000,
      })
      return
    end
  end

  -- Open a vertical split on the right
  vim.cmd("botright 40vsplit")
  local buf                   = vim.api.nvim_get_current_buf()
  local win                   = vim.api.nvim_get_current_win()

  -- Tag the buffer so we can find it later
  vim.b[buf]._arduino_monitor = true

  -- Window aesthetics
  vim.wo[win].number          = false
  vim.wo[win].relativenumber  = false
  vim.wo[win].signcolumn      = "no"
  vim.wo[win].winfixwidth     = true
  vim.wo[win].statusline      = " 󰻕  Arduino Monitor  (q to close)"

  -- Start the monitor in a terminal
  local term_id               = vim.fn.termopen({ "arduino-cli", "monitor" }, {
    on_exit = function(_, code)
      vim.schedule(function()
        notify("Arduino: monitor stopped (exit " .. code .. ")", "info", {
          title = "Arduino CLI",
          icon = "󰻕",
          timeout = 3000,
        })
        -- Auto-close the window if it's still open
        if vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end)
    end,
  })

  if term_id == 0 or term_id == -1 then
    notify("Failed to start arduino-cli monitor", "error", {
      title = "Arduino CLI Error",
      icon = "",
      timeout = 4000,
    })
    return
  end

  -- q closes the monitor and kills the job
  vim.keymap.set("n", "q", function()
    vim.fn.jobstop(term_id)
  end, { buffer = buf, desc = "Stop Arduino Monitor" })

  -- Drop into insert/terminal mode so output streams immediately
  vim.cmd("startinsert")

  notify("Arduino: monitor started", "info", {
    title = "Arduino CLI",
    icon = "󰻕",
    timeout = 2000,
  })
end

-- Keymaps
vim.keymap.set('n', '<leader>au', M.arduino_runner, { desc = "Arduino Upload" })
vim.keymap.set('n', '<leader>am', M.arduino_monitor, { desc = "Arduino Monitor" })

return M
