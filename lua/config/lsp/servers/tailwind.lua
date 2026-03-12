return function(mason_bin)
  return {
    name = "tailwindcss",
    cmd = { mason_bin .. "tailwindcss-language-server", "--stdio" },
    filetypes = { "typescriptreact", "javascriptreact", "svelte", "vue", "css", "scss", "less" },
    root_patterns = { "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.ts" },
  }
end
