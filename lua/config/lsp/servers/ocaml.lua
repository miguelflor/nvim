return function(mason_bin)
  local ocamllsp_bin = mason_bin .. "ocamllsp"
  if vim.fn.executable(ocamllsp_bin) == 0 then
    ocamllsp_bin = "ocamllsp"
  end

  return {
    name = "ocamllsp",
    cmd = { ocamllsp_bin },
    filetypes = { "ocaml", "ocamlinterface" },
    root_patterns = { "dune", "dune-project", "_opam", "esy.json", "package.json", ".git" },
  }
end
