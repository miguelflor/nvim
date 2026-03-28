return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false }, -- No ghost text/auto-complete
      panel = { enabled = false },      -- No suggestion panel
    },
  },

  -- 2. The Chat Plugin
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make utf8", -- Only needed if you want high-perf tiktoken
    opts = {
      model = "claude-haiku-4.5",
      mappings = {
        close = {
          normal = "",
          insert = ""
        }
      },
      -- See Configuration section for options
      debug = false,
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<cr>",  desc = "CopilotChat - Toggle" },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
    },
  },
}
