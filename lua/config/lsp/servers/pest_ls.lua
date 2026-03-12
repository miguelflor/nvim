return function(mason_bin)
  return {
    name = "pest_ls",
    cmd = {mason_bin .. "pest-language-server" },
    filetypes = { "pest" },
    settings = {
      pest = {
        -- add any pest-ls specific settings here, even empty tables work
      }
    },
    root_patterns = { ".git" },
  }
end
