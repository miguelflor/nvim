return {
  filetypes = { 'arduino' },
  root_markers = { ".arduino_config.lua", "sketch.yaml", ".git" },
  cmd = {
    'arduino-language-server',
    '-cli', 'arduino-cli',
    '-cli-config', vim.fn.expand('$HOME/.arduino15/arduino-cli.yaml'),
    '-clangd', vim.fn.exepath('clangd') or '/usr/bin/clangd',
    '-fqbn', 'arduino:avr:uno',   -- default, overridden below per-project
  },
  before_init = function(_, config)
    local cfg_file = config.root_dir .. '/.arduino_config.lua'
    local loader = loadfile(cfg_file)
    if loader then
      local ok, settings = pcall(loader)
      if ok and settings and settings.board then
        for i, v in ipairs(config.cmd) do
          if v == '-fqbn' then
            config.cmd[i + 1] = settings.board
            break
          end
        end
      end
    end
  end,
  capabilities = {
    textDocument = {
      ---@diagnostic disable-next-line: assign-type-mismatch
      semanticTokens = vim.NIL,
    },
    workspace = {
      ---@diagnostic disable-next-line: assign-type-mismatch
      semanticTokens = vim.NIL,
    },
  },
}
