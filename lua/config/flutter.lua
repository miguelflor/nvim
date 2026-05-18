local M = {}

function M.setup_tools()
  local ok, tools = pcall(require, "flutter-tools")
  if not ok then
    return
  end

  tools.setup({
    lsp = {
      on_attach = function(_, bufnr)
        require("config.keymaps").lsp(bufnr)
      end

    }
  })
end

return M
