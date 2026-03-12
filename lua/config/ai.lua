local M = {}

function M.codecompanion()
  local ok, codecompanion = pcall(require, "codecompanion")
  if not ok then
    return
  end

  codecompanion.setup({
    strategies = {
      chat = { adapter = "openai" },
      inline = { adapter = "openai" },
    },
    adapters = {
      openai = {
        api_key = function()
          return os.getenv("OPENAI_API_KEY") or ""
        end,
      },
    },
    ui = {
      border = "rounded",
    },
  })
end

return M
