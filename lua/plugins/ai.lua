return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make utf8",
    opts = {
      model = "claude-haiku-4.5",
      mappings = {
        close = {
          normal = "",
          insert = ""
        }
      },
      debug = false,
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<cr>",  desc = "CopilotChat - Toggle" },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
    },
  },
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    dependencies = {
      {
        "folke/snacks.nvim",
        opts = {
          input = {},
          terminal = {},
          picker = {
            actions = {
              opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
            },
            win = {
              input = {
                keys = {
                  ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
    config = function()
      require("config.ai").opencode_setup()
    end,
  }
}
