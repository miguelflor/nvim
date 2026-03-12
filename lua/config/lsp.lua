local utils = require("utils")
local server_configs = require("config.lsp.servers")

local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

local function on_attach(_, bufnr)
  require("config.keymaps").lsp(bufnr)
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
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

  local group = vim.api.nvim_create_augroup("UserNativeLsp", { clear = true })
  for name, server in pairs(server_configs) do
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = server.filetypes,
      callback = function(args)
        local bufnr = args.buf
        local existing = vim.lsp.get_clients({ bufnr = bufnr, name = name });
        if existing and #existing > 0 then
          return
        end

        if vim.fn.executable(server.cmd[1]) == 0 then
          vim.notify(("LSP %s not available"):format(name), vim.log.levels.WARN)
          return
        end

        local root_dir = utils.root_dir(bufnr, server.root_patterns or { ".git" })
        local config = vim.tbl_deep_extend("force", server, {
          name = name,
          root_dir = root_dir,
          on_attach = on_attach,
          capabilities = capabilities,
        })
        config.root_patterns = nil
        vim.lsp.start(config)
      end,
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
