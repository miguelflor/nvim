local M = {}

function M.setup(on_attach, capabilities)
  local ok, null_ls = pcall(require, "null-ls")
  if not ok then
    return
  end

  local sources = {}
  if null_ls.builtins and null_ls.builtins.formatting and null_ls.builtins.formatting.prettierd then
    table.insert(sources, null_ls.builtins.formatting.prettierd)
  end

  null_ls.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      -- Disable diagnostics from none-ls to avoid conflicts with ESLint
      client.server_capabilities.diagnosticProvider = false
      on_attach(client, bufnr)
    end,
    sources = sources,
    -- Explicitly disable diagnostic-related capabilities
    diagnostics_format = "[#{c}] #{m} (#{s})",
    update_in_insert = false,
  })
end

return M
