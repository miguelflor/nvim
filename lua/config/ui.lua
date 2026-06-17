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

function M.mode_toggle()
  local ok, rose = pcall(require, "rose-pine")
  if not ok then return end

  -- rose-pine's colorscheme() always resets vim.g.colors_name to "rose-pine",
  -- so detect the active variant via vim.o.background instead (set per-variant).
  local to_dark = vim.o.background == "light"
  local variant = to_dark and "moon" or "dawn"

  rose.setup({
    variant = variant,
    styles = {
      bold = true,
      italic = false,
      -- Transparency only looks right on the dark variant over a dark terminal;
      -- the light "dawn" variant needs its own opaque background painted.
      transparency = to_dark,
    },
  })
  vim.cmd("colorscheme rose-pine-" .. variant)
end

vim.api.nvim_create_user_command("ModeToggle", M.mode_toggle, {})

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
        -- Active LSP engine (see config.coc). Always shown: reflects the global
        -- engine state even on filetypes coc doesn't serve.
        {
          function()
            return require("config.coc").current_engine() == "coc" and "󰚩 coc" or " native"
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
    win_options = {
      signcolumn = "yes:2"
    },
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
