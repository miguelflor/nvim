local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

local function on_attach(_, bufnr)
  require("config.keymaps").lsp(bufnr)
end

local lsp_servers = {
  "ts_ls","vue_ls", "lua_ls", "rust_analyzer", "docker_language_server", "pest_ls",
  "tailwindcss", "cssls", "clangd", "pyright", "eslint", "flux-lsp", "texlab",
  "ocamllsp", "arduino_language_server"
}

local signs = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "󰋽" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

function M.setup()
  vim.diagnostic.config({
    virtual_text = { spacing = 2, prefix = "●" },
    severity_sort = true,
    float = { border = "rounded" },
    underline = true,
    update_in_insert = false,
  })

  local orig_open_float = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return orig_open_float(contents, syntax, opts, ...)
  end

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

  vim.lsp.enable(lsp_servers)

  for _, server_name in ipairs(lsp_servers) do
    vim.lsp.config(server_name, {
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end
end

function M.setup_null_ls()
  require("config.lsp.null-ls").setup(on_attach, capabilities)
end

function M.setup_jdtls()
  require("config.lsp.jdtls").setup(on_attach, capabilities)
end

return M
