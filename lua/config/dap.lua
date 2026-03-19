local M = {}

function M.dap_java()
  local dap = require("dap")
  local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/")
  local codelldb_path = mason_path .. "adapter/codelldb"
  local liblldb_path = mason_path .. "lldb/lib/liblldb.so" -- .dylib on macOS

  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = codelldb_path,
      args = { "--port", "${port}" },
    },
  }

  dap.configurations.java = {
    {
      type = 'java',
      request = 'launch',
      name = 'Debug (Launch) - Current File',
      args = function() return vim.fn.input('Args: ') end,
    },
  }

  dap.configurations.rust = {
    {
      name = "Launch binary",
      type = "codelldb",
      request = "launch",
      program = function()
        -- Builds the project and returns the binary path
        vim.fn.system("cargo build 2>&1")
        local crate = vim.fn.trim(vim.fn.system(
        "cargo metadata --no-deps --format-version 1 | python3 -c \"import sys,json; print(json.load(sys.stdin)['packages'][0]['name'])\""))
        return vim.fn.getcwd() .. "/target/debug/" .. crate
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
    },
    {
      name = "Launch binary (with args)",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to binary: ", vim.fn.getcwd() .. "/target/debug/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = function()
        local args = vim.fn.input("Args: ")
        return vim.split(args, " ")
      end,
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
  -- dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
  -- dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
  -- dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end

  -- ── keymaps defenitions ─────────────────────────────────────
  require("config.keymaps").dap()
end

return M
