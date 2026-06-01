return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = { "typescriptreact", "javascriptreact", "svelte", "vue", "css", "scss", "less" },
  root_markers = { "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.ts" },
}
