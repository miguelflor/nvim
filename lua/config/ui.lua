local M = {}

function M.colors()
  local ok, rose = pcall(require, "rose-pine")
  if not ok then
    return
  end

  rose.setup({
    variant = "moon",
    styles = {
      bold = true,
      italic = false,
      transparency = true,
    },
  })

  vim.cmd("colorscheme rose-pine")
end

function M.statusline()
  local ok, lualine = pcall(require, "lualine")
  if not ok then
    return
  end
  lualine.setup({
    options = {
      theme = "auto",
      globalstatus = false,
      component_separators = "",
      section_separators = "",
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff" },
      lualine_c = { { "filename", path = 1 } },
      lualine_x = {
        -- The Copilot Model Component
        {
          function()
            local chat = require("CopilotChat")
            -- Shows the current model name
            return "󱚥 " .. chat.config.model
          end,
          cond = function()
            -- Only show if CopilotChat is actually loaded
            return vim.bo.filetype == "copilot-chat"
          end,
          color = { fg = "#6272a4" }, -- A subtle purple/blue color
        },
        "diagnostics",
        "filetype"
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  })
end

function M.oil()
  require("oil").setup({
    keymaps = {
      ["q"] = "actions.close",
    },
    float = {
      padding = 2,
      max_width = 80,
      max_height = 30,
      border = "rounded"
    },
    default_file_explorer = true,
  })
  require("config.keymaps").oil()
end

function M.explorer()
  local ok, nvim_tree = pcall(require, "nvim-tree")
  if not ok then
    return
  end

  nvim_tree.setup({
    renderer = {
      group_empty = true,
      highlight_git = true,
      indent_markers = { enable = true },
    },
    filters = {
      custom = { ".git", "node_modules" },
    },
    update_focused_file = {
      enable = true,       -- highlights current file
      update_root = false, -- set to true if you also want the root to change
    },
    view = {
      width = {
        min = 36,
        max = 60,
        padding = 2,
      },
      number = false,
      relativenumber = true,
    },
  })
end

function M.dashboard()
  local ok, alpha = pcall(require, "alpha")
  if not ok then
    return
  end

  local dashboard = require("alpha.themes.dashboard")
  dashboard.section.header.val = {
    "███╗   ██╗██╗   ██╗██╗███╗   ███╗",
    "████╗  ██║██║   ██║██║████╗ ████║",
    "██╔██╗ ██║██║   ██║██║██╔████╔██║",
    "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
    "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
    "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
  }
  dashboard.section.buttons.val = {
    dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
    dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
    dashboard.button("p", "  Projects", ":Telescope projects<CR>"),
    dashboard.button("s", "  Restore session", ":SessionRestore<CR>"),
    dashboard.button("c", "  Edit config", ":cd ~/.config/nvim | e init.lua<CR>"),
    dashboard.button("q", "  Quit", ":qa<CR>"),
  }
  dashboard.section.footer.val = "Lazy · Mason · Native LSP"

  alpha.setup(dashboard.config)
end

return M
