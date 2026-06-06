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
        -- Active LSP engine for switchable filetypes (see config.coc)
        {
          function()
            return require("config.coc").is_coc_ft(vim.bo.filetype) and "󰚩 coc" or " native"
          end,
          cond = function()
            return require("config.coc").is_managed_ft(vim.bo.filetype)
          end,
          color = { fg = "#6272a4" },
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

function M.dashboard()
  local ok, alpha = pcall(require, "alpha")
  if not ok then
    return
  end

  local dashboard = require("alpha.themes.dashboard")
  dashboard.section.header.val = {
    "███████╣██╣      ██████╣ ██████╣ ██╣   ██╣██╣███╣   ███╣",
    "██╔════╝██║     ██╔═══██╣██╔══██╣██║   ██║██║████╣ ████║",
    "█████╣  ██║     ██║   ██║██████╔╝██║   ██║██║██╔████╔██║",
    "██╔══╝  ██║     ██║   ██║██╔══██╣╚██╣ ██╔╝██║██║╚██╔╝██║",
    "██║     ███████╣╚██████╔╝██║  ██║ ╚████╔╝ ██║██║ ╚═╝ ██║",
    "╚═╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
  }
  dashboard.section.buttons.val = {
    dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
    dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
    dashboard.button("p", "  Projects", ":Telescope projects<CR>"),
    dashboard.button("c", "  Edit config", ":cd ~/.config/nvim | e init.lua<CR>"),
    dashboard.button("q", "  Quit", ":qa<CR>"),
  }
  dashboard.section.footer.val = "FlorVim"

  alpha.setup(dashboard.config)
end

return M
