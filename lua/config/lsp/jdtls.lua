local M = {}

function M.setup(on_attach,capabilities)
  local ok, jdtls = pcall(require, "jdtls")
  local home = os.getenv('HOME')
  if not ok then
    return
  end

  local on_attach_local = function(client, bufnr)
    -- This line tells the LSP: "Don't touch my colors, let Tree-sitter do it"
    client.server_capabilities.semanticTokensProvider = nil
    on_attach(client,bufnr)

  end

  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local workspace_dir = home .. '/.cache/jdtls/workspace/' .. project_name

  local config = {
    cmd = {
      'jdtls', -- This works if 'jdtls' is in your PATH (Mason does this)
      '-data', workspace_dir,
    },

    -- This is the "root marker". It tells the LSP where the project starts.
    root_dir = jdtls.setup.find_root({ '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }),

    -- Here you can pass standard LSP capabilities
    capabilities = capabilities,
    on_attach = on_attach_local
  }

  -- This starts the server and attaches it to the current buffer
  jdtls.start_or_attach(config)

  -- vim.lsp.enable("jdtls")
end

return M
