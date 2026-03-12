return function(mason_bin)
  return {
    name = "clangd",
    cmd = { mason_bin .. "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "llvm" },
    root_patterns = { "compile_commands.json", "compile_flags.txt", ".git" },
  }
end
