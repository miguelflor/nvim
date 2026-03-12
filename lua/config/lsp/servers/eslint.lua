---@param mason_bin string
return function(mason_bin)
  return {
    name = "eslint",
    cmd = { vim.fs.joinpath(mason_bin, "vscode-eslint-language-server"), "--stdio" },
    filetypes = {
      "javascript", "javascriptreact", "javascript.jsx",
      "typescript", "typescriptreact", "typescript.tsx",
      "vue", "svelte", "astro",
    },
    root_dir = function(fname)
      return vim.fs.root(fname, { 
        'eslint.config.js',
        'eslint.config.mjs',
        'eslint.config.cjs',
        'eslint.config.ts',
        '.eslintrc.js',
        '.eslintrc.cjs',
        '.eslintrc.yaml',
        '.eslintrc.yml',
        '.eslintrc.json',
        '.eslintrc',
        'package.json',
        '.git'
      })
    end,
    
    -- Disable pull diagnostics
    capabilities = (function()
      local caps = vim.lsp.protocol.make_client_capabilities()
      caps.textDocument.diagnostic = nil
      return caps
    end)(),
    
    on_attach = function(client, bufnr)
      vim.api.nvim_buf_create_user_command(bufnr, 'LspEslintFixAll', function()
        client.request_sync('workspace/executeCommand', {
          command = 'eslint.applyAllFixes',
          arguments = {
            {
              uri = vim.uri_from_bufnr(bufnr),
              version = vim.lsp.util.buf_versions[bufnr],
            },
          },
        }, nil, bufnr)
      end, {})
    end,
    
     settings = {
      validate = 'on',
      packageManager = nil,
      useESLintClass = false,
      experimental = {
        useFlatConfig = false,
      },
      codeActionOnSave = {
        enable = false,
        mode = 'all',
      },
      format = true,
      quiet = false,
      onIgnoredFiles = 'off',
      rulesCustomizations = {},
      run = 'onType',
      problems = {
        shortenToSingleLine = false,
      },
      -- nodePath configures the directory in which the eslint server should start its node_modules resolution.
      -- This path is relative to the workspace folder (root dir) of the server instance.
      nodePath = '',
      -- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
      workingDirectory = { mode = 'location' },
      codeAction = {
        disableRuleComment = {
          enable = true,
          location = 'separateLine',
        },
        showDocumentation = {
          enable = true,
        },
      },
    },   
    handlers = {
      ['eslint/openDoc'] = function(_, result)
        if result then vim.ui.open(result.url) end
        return {}
      end,
      ['eslint/confirmESLintExecution'] = function() return 4 end,
      ['eslint/probeFailed'] = function()
        vim.notify('ESLint probe failed', vim.log.levels.WARN)
        return {}
      end,
      ['eslint/noLibrary'] = function()
        vim.notify('ESLint: Unable to find ESLint library', vim.log.levels.WARN)
        return {}
      end,
    },
  }
end
