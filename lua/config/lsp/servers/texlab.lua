return function(mason_bin)
  return {
    name = "texlab",
    cmd = { mason_bin .. "texlab" },
    filetypes = { "tex", "plaintex", "bib" },
    root_patterns = { ".latexmkrc", ".git" },
  }
end
