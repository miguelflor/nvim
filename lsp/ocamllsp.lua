local ocamllsp_bin = "ocamllsp"
if vim.fn.executable(ocamllsp_bin) == 0 then
  ocamllsp_bin = "ocamllsp"
end

return {
  cmd = { ocamllsp_bin },
  filetypes = { "ocaml", "ocamlinterface" },
  root_patterns = { "dune", "dune-project", "_opam", "esy.json", "package.json", ".git" },
}
