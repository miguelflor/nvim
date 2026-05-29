return {
  filetypes = { 'arduino' },
  root_markers = { "sketch.yaml", ".git" },
  cmd = {
    'arduino-language-server',
  },
  before_init = function(params, _)
    -- arduino-language-server panics on workspace/semanticTokens/refresh
    -- (unimplemented handler). Strip the capability so clangd never sends it.
    if params.capabilities then
      if params.capabilities.textDocument then
        params.capabilities.textDocument.semanticTokens = nil
      end
      if params.capabilities.workspace then
        params.capabilities.workspace.semanticTokens = nil
      end
    end
  end,
}
