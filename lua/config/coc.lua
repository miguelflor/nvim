local M = {}

-- Each group can be served by EITHER native LSP (the listed servers, configured
-- in lsp/<name>.lua) OR coc.nvim, but only one at a time. To make a new language
-- switchable, add an entry here and a languageserver block in coc-settings.json.
M.engines = {
  ts = {
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    servers = { "vtsls", "vue_ls" },
  },
  -- Example, when you want Rust on coc too:
  -- rust = { filetypes = { "rust" }, servers = { "rust_analyzer" } },
}

-- Groups currently served by coc (set of group-name -> true). Default: none,
-- i.e. everything starts on native LSP. Persisted on vim.g so it survives
-- reloads within a session.
local function coc_groups()
  vim.g.coc_groups = vim.g.coc_groups or {}
  return vim.g.coc_groups
end

local function set_group(group, on)
  local g = vim.deepcopy(coc_groups())
  g[group] = on or nil
  vim.g.coc_groups = g
end

-- Reverse lookup: filetype -> group name (or nil if not switchable).
local ft_to_group = {}
for group, spec in pairs(M.engines) do
  for _, ft in ipairs(spec.filetypes) do
    ft_to_group[ft] = group
  end
end

-- All native servers across every switchable group (so lsp.lua can recognise
-- which servers it must NOT enable generically / bind keymaps for).
function M.managed_servers()
  local out = {}
  for _, spec in pairs(M.engines) do
    for _, s in ipairs(spec.servers) do
      out[#out + 1] = s
    end
  end
  return out
end

-- Is the given filetype currently served by coc?
function M.is_coc_ft(ft)
  local group = ft_to_group[ft]
  return group ~= nil and coc_groups()[group] == true
end

-- Is the given filetype managed by the switch at all (coc or native)?
function M.is_managed_ft(ft)
  return ft_to_group[ft] ~= nil
end

-- Every buffer-local mapping either engine may set, cleared before binding the
-- active engine's keys when swapping on an already-open buffer.
local clear_maps = {
  n = {
    "gd", "gD", "gi", "gr", "K", "<C-b>", "<leader>rn", "<leader>ca", "<leader>cf",
    "[d", "]d", "<leader>ds", "<leader>wa", "<leader>wr", "<leader>wl",
  },
  v = { "<leader>ca" },
  i = { "<Tab>", "<S-Tab>", "<CR>", "<C-Space>" },
}

local function clear_buf_maps(bufnr)
  for mode, lhss in pairs(clear_maps) do
    for _, lhs in ipairs(lhss) do
      pcall(vim.keymap.del, mode, lhs, { buffer = bufnr })
    end
  end
end

-- Apply the active engine's keymaps + completion gating to one managed buffer.
local function apply_buf(bufnr)
  local ft = vim.bo[bufnr].filetype
  if not M.is_managed_ft(ft) then
    return
  end
  clear_buf_maps(bufnr)
  if M.is_coc_ft(ft) then
    require("config.keymaps").coc(bufnr)
    vim.b[bufnr].completion = false -- keep blink out of coc filetypes
  else
    require("config.keymaps").lsp(bufnr)
    vim.b[bufnr].completion = true -- let blink drive completion
  end
end

local function reapply_group_buffers(group)
  local fts = {}
  for _, ft in ipairs(M.engines[group].filetypes) do
    fts[ft] = true
  end
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) and fts[vim.bo[b].filetype] then
      apply_buf(b)
    end
  end
end

-- coc is a single global daemon: start it the first time any group needs it,
-- stop it (freeing the node process) once no group is using it.
local function any_coc_group()
  return next(coc_groups()) ~= nil
end

local function ensure_coc_started()
  if vim.fn.exists(":CocStart") == 0 then
    -- Not loaded yet this session: loading auto-starts and enables coc.
    require("lazy").load({ plugins = { "coc.nvim" } })
  else
    vim.cmd("silent! CocStart")
    vim.cmd("silent! CocEnable")
  end
end

local function stop_coc_if_idle()
  -- exists(":Cmd") returns 2 for a user command, so test ~= 0, not == 1.
  if not any_coc_group() and vim.fn.exists(":CocDisable") ~= 0 then
    vim.cmd("silent! CocDisable")
    pcall(vim.fn["coc#rpc#stop"]) -- kill the server process, not just detach
  end
end

function M.use_native(group)
  set_group(group, false)
  stop_coc_if_idle()
  vim.lsp.enable(M.engines[group].servers, true)
  reapply_group_buffers(group)
  vim.notify(("LSP engine [%s]: native"):format(group), vim.log.levels.INFO)
end

function M.use_coc(group)
  set_group(group, true)
  vim.lsp.enable(M.engines[group].servers, false) -- stops their clients
  ensure_coc_started()
  reapply_group_buffers(group)
  vim.notify(("LSP engine [%s]: coc.nvim"):format(group), vim.log.levels.INFO)
end

function M.toggle(group)
  if coc_groups()[group] then
    M.use_native(group)
  else
    M.use_coc(group)
  end
end

-- Bring servers in line with the persisted state at startup.
function M.apply_startup_state()
  for group in pairs(M.engines) do
    if coc_groups()[group] then
      M.use_coc(group)
    else
      vim.lsp.enable(M.engines[group].servers, true)
    end
  end
end

function M.setup()
  -- Re-apply the active engine whenever a managed buffer's filetype is set.
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("LspEngineSwitch", { clear = true }),
    pattern = vim.tbl_keys(ft_to_group),
    callback = function(ev)
      apply_buf(ev.buf)
    end,
  })

  -- :CocToggle [group]  — default group is the first/only one ("ts").
  vim.api.nvim_create_user_command("CocToggle", function(opts)
    local group = opts.args ~= "" and opts.args or next(M.engines)
    if not M.engines[group] then
      vim.notify("Unknown engine group: " .. group, vim.log.levels.ERROR)
      return
    end
    M.toggle(group)
  end, {
    nargs = "?",
    complete = function()
      return vim.tbl_keys(M.engines)
    end,
    desc = "Toggle a language group between native LSP and coc.nvim",
  })

  vim.keymap.set("n", "<leader>tc", function()
    M.toggle(next(M.engines))
  end, { desc = "Toggle coc / native LSP engine" })
end

return M
