local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

-- Keymaps + completion for "switchable" filetypes (those that can run on
-- either native LSP or coc.nvim) are driven by config.coc; generic servers
-- must not bind keymaps over them.
local coc = require("config.coc")

local function on_attach(_, bufnr)
  if not coc.is_managed_ft(vim.bo[bufnr].filetype) then
    require("config.keymaps").lsp(bufnr)
  end
end

-- dartls is not in the list because flutter-tools already handles that.
-- Servers in config.coc.engines (e.g. vtsls, vue_ls) are configured below and
-- enabled by config.coc, since they are toggled against coc.nvim (:CocToggle).
M.lsp_servers = {
  "lua_ls", "rust_analyzer", "docker_language_server", "pest_ls",
  "tailwindcss", "cssls", "clangd", "pyright", "eslint", "flux-lsp", "texlab",
  "ocamllsp", "arduino_language_server", "lemminx", "erlang_ls", "gopls", "zls",
  "kotlin_lsp"
}

local signs = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "󰋽" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

function M.setup()
  -- Registers :CocToggle, the engine-switch autocmd and keymap. Runs at
  -- startup so toggling works before coc.nvim is ever loaded.
  coc.setup()

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
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
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
    vim.api.nvim_set_option_value("modifiable", true, { buf = lsplog_buf })
    vim.api.nvim_buf_set_lines(lsplog_buf, 0, -1, false, lines)
    vim.api.nvim_set_option_value("modifiable", false, { buf = lsplog_buf })
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

  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
  if not vim.env.PATH:find(mason_bin, 1, true) then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
  end

  for _, server_name in ipairs(M.lsp_servers) do
    vim.lsp.config(server_name, {
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end

  vim.lsp.enable(M.lsp_servers)

  -- Switchable servers (vtsls, vue_ls, …) keep their own on_attach from
  -- lsp/<name>.lua; just give them the shared completion capabilities. They are
  -- enabled/disabled by config.coc according to the persisted engine state.
  for _, server_name in ipairs(coc.managed_servers()) do
    vim.lsp.config(server_name, { capabilities = capabilities })
  end
  coc.apply_startup_state()
end

function M.setup_conform()
  require("conform").setup({
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      kotlin = {"ktlint"},
      python = { "ruff_format" },
      go = { "goimports" },
      vue = { "prettierd" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      css = { "prettierd" },
      html = { "prettierd" },
      json = { "prettierd" },
    },
    format_on_save = function(bufnr)
      -- disabled globally; add filetype exceptions here to re-enable selectively
      -- e.g.: if vim.bo[bufnr].filetype == "go" then return { timeout_ms = 500 } end
      return nil
    end,
  })
end

function M.setup_null_ls()
  require("config.lsp.null-ls").setup(on_attach, capabilities)
end

function M.setup_jdtls()
  require("config.lsp.jdtls").setup(on_attach, capabilities)
end

return M
