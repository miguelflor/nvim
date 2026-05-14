local M = {}

function M.setup()
  local ok, blink = pcall(require, "blink.cmp")
  if not ok then
    return
  end

  blink.setup({
    keymap = {
      preset        = "none",
      ["<C-Space>"] = { "show", "fallback" },
      ["<C-e>"]     = { "cancel", "fallback" },
      ["<CR>"]      = { "select_and_accept", "fallback" },
      ["<C-b>"]     = { "scroll_documentation_up", "fallback" },
      ["<C-f>"]     = { "scroll_documentation_down", "fallback" },
      ["<Tab>"]     = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"]   = { "select_prev", "snippet_backward", "fallback" },
    },
    completion = {
      menu = {
        border = "rounded",
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = "rounded" },
      },
      list = {
        selection = { preselect = false, auto_insert = false },
      },
    },
    snippets = {
      preset = "default",
    },
    sources = {
      default = { "lsp", "snippets", "path", "buffer" },
    },
    fuzzy = { implementation = "lua" },
  })
end

return M
