local M = {}

function M.setup()
  local ok, project = pcall(require, "project")
  if not ok then
    vim.notify("project plugin not loaded!")
    return
  end

  project.setup({
    lsp = {
      enabled = true,
      use_pattern_matching = true
    },
    patterns = {
      '.git',
      '.github',
      '_darcs',
      '.hg',
      '.bzr',
      '.svn',
      'Pipfile',
      'pyproject.toml',
      '.pre-commit-config.yaml',
      '.pre-commit-config.yml',
      '.csproj',
      '.sln',
      '.nvim.lua',
      '.neoconf.json',
      'neoconf.json',
      'sketch.yaml'
    },
  })

  require("telescope").load_extension('projects')
end

return M
