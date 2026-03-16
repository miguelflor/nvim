local M = {}

function M.setup(on_attach, capabilities)
  local ok, jdtls = pcall(require, "jdtls")
  local home = os.getenv('HOME')
  if not ok then
    return
  end

  local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
  -- Paths to the debug adapter bundles installed by Mason
  local bundles = {
    vim.fn.glob(
      mason_path .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
      true
    ),
  }

  -- Include vscode-java-test bundles if installed
  local java_test_bundles = vim.split(vim.fn.glob(mason_path .. "/java-test/extension/server/*.jar", true), "\n")

  local excluded = {
    "com.microsoft.java.test.runner-jar-with-dependencies.jar",
    "jacocoagent.jar",
  }
  for _, java_test_jar in ipairs(java_test_bundles) do
    local fname = vim.fn.fnamemodify(java_test_jar, ":t")
    if not vim.tbl_contains(excluded, fname) then
      table.insert(bundles, java_test_jar)
    end
  end



  local on_attach_local = function(client, bufnr)
    -- This line tells the LSP: "Don't touch my colors, let Tree-sitter do it"
    client.server_capabilities.semanticTokensProvider = nil
    if not vim.treesitter.highlighter.active[bufnr] then
      vim.treesitter.start(bufnr, "java")
    end
    require("config.keymaps").jdtls_debug()
    require("jdtls").setup_dap({ hotcodereplace = "auto" })
    require("jdtls.dap").setup_dap_main_class_configs()
    on_attach(client, bufnr)
  end

  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local workspace_dir = home .. '/.cache/jdtls/workspace/' .. project_name
  local root = jdtls.setup.find_root({ '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' })

  local config = {
    cmd = {
      'jdtls', -- This works if 'jdtls' is in your PATH (Mason does this)
      '-data', workspace_dir,
    },
    init_options = {
      bundles = bundles, -- <-- this registers the debug adapter with jdtls
    },

    -- This is the "root marker". It tells the LSP where the project starts.
    root_dir = root,

    -- Here you can pass standard LSP capabilities
    capabilities = capabilities,
    on_attach = on_attach_local
  }

  -- This starts the server and attaches it to the current buffer
  jdtls.start_or_attach(config)
  
  -- Setup DAP with the root directory
  require("config.dap").dap_java()
end

return M
