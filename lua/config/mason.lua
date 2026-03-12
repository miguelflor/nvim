local M = {}

function M.setup()
  local ok, mason = pcall(require, "mason")
  if not ok then
    return
  end

  mason.setup({
    ui = {
      border = "rounded",
      icons = {
        package_installed = "",
        package_pending = "",
        package_uninstalled = "",
      },
    },
  })

  local ok_registry, registry = pcall(require, "mason-registry")
  if not ok_registry then
    return
  end

  local ensure = {
    "lua-language-server",
    "typescript-language-server",
    "tailwindcss-language-server",
    "css-lsp",
    "clangd",
    "pyright",
    "eslint-lsp",
    "flux-lsp",
    "eslint_d",
    "prettierd",
    "copilot-language-server",
    "jdtls",
    "texlab",
  }

  for _, name in ipairs(ensure) do
    local ok_pkg, pkg = pcall(registry.get_package, name)
    if ok_pkg and not pkg:is_installed() then
      pkg:install()
    end
  end
end

return M
