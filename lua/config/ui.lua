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
      transparency = false,
    },
  })

  vim.cmd("colorscheme rose-pine")
end

function M.mode_toggle()
  local ok, rose = pcall(require, "rose-pine")
  if not ok then return end

  -- rose-pine's colorscheme() always resets vim.g.colors_name to "rose-pine",
  -- so detect the active variant via vim.o.background instead (set per-variant).
  -- local to_dark = vim.o.background == "light"
  local variant = to_dark and "moon" or "dawn"

  rose.setup({
    variant = variant,
    styles = {
      bold = true,
      italic = false,
      -- Transparency only looks right on the dark variant over a dark terminal;
      -- the light "dawn" variant needs its own opaque background painted.
      transparency = false,
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

function M.tabby()
  local theme = {
    fill = 'TabLineFill',
    -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
    head = 'TabLine',
    current_tab = 'TabLineSel',
    tab = 'TabLine',
    win = 'TabLine',
    tail = 'TabLine',
  }
  require('tabby').setup({
    line = function(line)
      return {
        {
          { '  ', hl = theme.head },
          line.sep('', theme.head, theme.fill),
        },
        line.tabs().foreach(function(tab)
          local hl = tab.is_current() and theme.current_tab or theme.tab
          return {
            line.sep('', hl, theme.fill),
            tab.is_current() and '' or '󰆣',
            tab.number(),
            tab.name(),
            tab.close_btn(''),
            line.sep('', hl, theme.fill),
            hl = hl,
            margin = ' ',
          }
        end),
        line.spacer(),
        line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
          return {
            line.sep('', theme.win, theme.fill),
            win.is_current() and '' or '',
            win.buf_name(),
            line.sep('', theme.win, theme.fill),
            hl = theme.win,
            margin = ' ',
          }
        end),
        {
          line.sep('', theme.tail, theme.fill),
          { '  ', hl = theme.tail },
        },
        hl = theme.fill,
      }
    end,
    -- option = {}, -- setup modules' option,
  })
end

return M
