return {
  cmd = {
    'java',
    '-cp',
    '/home/miguel/lsp/lemminx/org.eclipse.lemminx/target/org.eclipse.lemminx-uber.jar'
    .. ':/home/miguel/lsp/lemminx-maven/lemminx-maven/target/deps/*',
    'org.eclipse.lemminx.XMLServerLauncher',
  },
  filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg' },
  root_markers = { 'pom.xml', '.git' },
  settings = {
    xml = {
      maven = {
        fetchExternalResources = true,
        updateRecentArtifacts = true,
      },
    }
  }
}
