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
  "ts_ls", "vue_ls", "lua_ls", "rust_analyzer", "docker_language_server", "pest_ls",
  "tailwindcss", "cssls", "clangd", "pyright", "eslint", "flux-lsp", "texlab",
  "ocamllsp", "arduino_language_server", "lemminx"
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

  vim.api.nvim_create_user_command("LspInfo", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
      vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
      return
    end
    local lines = { "LSP clients for buffer " .. vim.api.nvim_get_current_buf() .. ":", "" }
    for _, client in ipairs(clients) do
      table.insert(lines, "  Client : " .. client.name .. " (id=" .. client.id .. ")")
      table.insert(lines, "  Cmd    : " .. vim.inspect(client.config.cmd))
      table.insert(lines, "  Root   : " .. (client.root_dir or "none"))
      table.insert(lines, "  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))
      table.insert(lines, "")
    end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.cmd("split")
    vim.api.nvim_win_set_buf(0, buf)
  end, {})

  local lsplog_buf = nil
  vim.api.nvim_create_user_command("LspLog", function(opts)
    local lines_count = tonumber(opts.args) or 100
    local log_path = vim.lsp.get_log_path()
    local lines = {}
    for line in io.lines(log_path) do
      table.insert(lines, line)
      if #lines > lines_count then table.remove(lines, 1) end
    end
    if lsplog_buf == nil or not vim.api.nvim_buf_is_valid(lsplog_buf) then
      lsplog_buf = vim.api.nvim_create_buf(false, true)
    end
    vim.api.nvim_buf_set_option(lsplog_buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(lsplog_buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(lsplog_buf, "modifiable", false)
    local win = nil
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(w) == lsplog_buf then
        win = w
        break
      end
    end
    if win == nil then
      vim.cmd("split")
      vim.api.nvim_win_set_buf(0, lsplog_buf)
    else
      vim.api.nvim_set_current_win(win)
    end
    vim.cmd("normal! G")
  end, { nargs = "?" })

  vim.lsp.enable(lsp_servers)

  for _, server_name in ipairs(lsp_servers) do
    vim.lsp.config(server_name, {
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end
end

function M.setup_conform()
  require("conform").setup({
    formatters_by_ft = {
      python = { "ruff_format" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  })
end

function M.setup_null_ls()
  require("config.lsp.null-ls").setup(on_attach, capabilities)
end

function M.setup_jdtls()
  require("config.lsp.jdtls").setup(on_attach, capabilities)
end

return M
