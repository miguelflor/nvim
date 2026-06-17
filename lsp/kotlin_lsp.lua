---@type vim.lsp.Config
-- JetBrains' official Kotlin LSP (Mason: kotlin-lsp). Provides far richer hover
-- documentation than the old fwcd kotlin-language-server. The Mason binary is
-- `intellij-server`; `--stdio` runs it over stdin/stdout for the LSP client.
return {
  cmd = { 'intellij-server', '--stdio' },
  filetypes = { 'kotlin' },
  root_markers = {
    'settings.gradle', 'settings.gradle.kts',
    'build.gradle', 'build.gradle.kts',
    'pom.xml', '.git',
  },
}
