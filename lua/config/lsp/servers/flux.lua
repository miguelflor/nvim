return function(mason_bin)
  return {
    name = "flux-lsp",
    cmd = { mason_bin .. "flux-lsp" },
    filetypes = { "flux" },
    root_patterns = { "flux.mod", ".git" },
  }
end
