local M = {}

function M.dap_java()
  local dap = require("dap")

  dap.configurations.java = {
    {
      type = 'java',
      request = 'launch',
      name = 'Debug (Launch) - Current File',
      args = function() return vim.fn.input('Args: ') end,
    },
  }
end

function M.setup()
  local dap = require("dap")
  local dapui = require("dapui")

  dap.breakpoints = dap.breakpoints or {}
  dap.configurations.java = dap.configurations.java or {}

  -- ── dap-ui setup ────────────────────────────────────────────────────────────
  dapui.setup({
    icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
    layouts = {
      {
        elements = {
          { id = "scopes",      size = 0.40 },
          { id = "breakpoints", size = 0.15 },
          { id = "stacks",      size = 0.30 },
          { id = "watches",     size = 0.15 },
        },
        size = 45,
        position = "left",
      },
      {
        elements = {
          { id = "repl",    size = 0.5 },
          { id = "console", size = 0.5 },
        },
        size = 12,
        position = "bottom",
      },
    },
  })

  vim.fn.sign_define("DapBreakpoint", {
    text = "●",
    texthl = "DapBreakpoint",
    linehl = "",
    numhl = "",
  })

  vim.fn.sign_define("DapBreakpointCondition", {
    text = "◆",
    texthl = "DapBreakpointCondition",
    linehl = "",
    numhl = "",
  })

  vim.fn.sign_define("DapLogPoint", {
    text = "◉",
    texthl = "DapLogPoint",
    linehl = "",
    numhl = "",
  })

  vim.fn.sign_define("DapStopped", {
    text = "▶",
    texthl = "DapStopped",
    linehl = "DapStoppedLine",
    numhl = "",
  })

  vim.fn.sign_define("DapBreakpointRejected", {
    text = "✗",
    texthl = "DapBreakpointRejected",
    linehl = "",
    numhl = "",
  })

  -- Colors
  vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
  vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f5a623" })
  vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
  vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })
  vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e2a2a" })
  vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#888888" })

  -- ── Auto open/close UI with DAP session ─────────────────────────────────────
  dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
  dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
  dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end

  -- ── keymaps defenitions ─────────────────────────────────────
  require("config.keymaps").dap()
end

return M
