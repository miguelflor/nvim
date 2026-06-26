local M = {}

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

local function lsp_root_run(builtin_name)
  return function()
    local builtin = require("telescope.builtin")
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local root = nil

    -- Use the first active client's root_dir (e.g., where pom.xml was found)
    if clients[1] then
      root = clients[1].config.root_dir
    end

    -- root needs to subset of vim.fn.getcwd() if not somethings wrong
    if root and vim.startswith(root, vim.fn.getcwd()) then
      builtin[builtin_name]({ search_dirs = { root } })
    else
      builtin[builtin_name]({ cwd = vim.fn.getcwd() }) -- Fallback to current working directory
    end
  end
end

function M.setup()
  map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search")
  map("n", "<leader>pf", lsp_root_run("find_files"), "Find files")
  map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, "Find files")
  map("n", "<leader>ps", lsp_root_run("live_grep"), "Live grep")
  map("n", "<leader>pg", lsp_root_run("git_status"), "Find changed files")
  map("n", "<leader>fp", function()
    require("telescope").extensions.projects.projects()
  end, "Projects")
  map("n", "<leader>pe", function()
    require("telescope.builtin").diagnostics()
  end, "Workspace diagnostics")


  map("v", "<A-j>", ":m '>+1<CR>gv=gv", "Move up");
  map("v", "<A-k>", ":m '<-2<CR>gv=gv", "Mode down");
  map("n", "<A-j>", ":m .+1<CR>==", "Move line down")
  map("n", "<A-k>", ":m .-2<CR>==", "Move line up")

  map('n', '<leader>mr', 'ciW<C-r>=<C-r>"<CR><Esc>', 'Evaluate expression under cursor')

  map("n", "<leader>ptd", "<cmd>TodoTelescope<CR>", "List TODOs")
  map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", "Toggle undotree")
  map("n", "<leader>gs", "<cmd>Git<CR>", "Fugitive status")

  map("n", "<leader>bn", "<cmd>bnext<CR>", "Next buffer")
  map("n", "<leader>bp", "<cmd>bprevious<CR>", "Prev buffer")
  map("n", "<leader>bd", "<cmd>bdelete<CR>", "Close buffer")

  map("n", "<C-h>", "<C-w>h", "Focus window left")
  map("n", "<C-j>", "<C-w>j", "Focus window below")
  map("n", "<C-k>", "<C-w>k", "Focus window above")
  map("n", "<C-l>", "<C-w>l", "Focus window right")

  map("n", "<C-d>", "<C-d>zz",  "Scroll down and recenter" )
  map("n", "<C-u>", "<C-u>zz",  "Scroll up and recenter" )

  map("n", "<leader>tc", "<cmd>tabclose<CR>", "Closes the current tab")
  map("n", "<leader>tn", "<cmd>tabnew<CR>", "Opens a new Tab")

  map("n", "<leader>qs", function() require("persistence").load() end, "Restore session (cwd)")
  map("n", "<leader>qS", function() require("persistence").select() end, "Select session")
  map("n", "<leader>ql", function() require("persistence").load({ last = true }) end, "Restore last session")
  map("n", "<leader>qr", function() require("persistence").stop() end, "Stop session saving")
  map("n", "<leader>qq", "<cmd>qa<CR>", "Quit Neovim")

  map("v", "<leader>y", '"+y', "Copy selection to clipboard")
  map("n", "<leader>Y", '<cmd>%y+<CR>', "Copy buffer to clipboard")

  map('t', '<Esc>', [[<C-\><C-n>]])
  -- Search and replaced
  map("n", "<leader>r", function()
    local word = vim.fn.expand("<cword>")
    vim.api.nvim_feedkeys(":%s/" .. word .. "/g", "n", false)
  end, "Replace word under cursor")


  -- Harpoon
  map("n", "<leader>h", function()
    local ok, mark = pcall(require, "harpoon.mark")
    if ok then
      mark.add_file()
    end
  end, "Harpoon add")
  map("n", "<leader>hh", function()
    local ok, ui = pcall(require, "harpoon.ui")
    if ok then
      ui.toggle_quick_menu()
    end
  end, "Harpoon menu")
  for i = 1, 4 do
    map("n", string.format("<C-%d>", i), function()
      local ok, ui = pcall(require, "harpoon.ui")
      if ok then
        ui.nav_file(i)
      end
    end, string.format("Harpoon file %d", i))
  end


  map("n", "<leader>lr", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
      vim.lsp.stop_client(client.id)
    end
    vim.defer_fn(function()
      vim.cmd("edit")
    end, 500) -- small delay to let the client fully stop before reattaching
  end, "Restart LSP")
end

function M.kulala()
  map("n", "<leader>Rs", function() require("kulala").run() end, "Send request")
  map("n", "<leader>Ra", function() require("kulala").run_all() end, "Send all requests")
  map("n", "<leader>Rb", function() require("kulala").scratchpad() end, "Open scratchpad")
end

function M.oil()
  map("n", "-", "<CMD>Oil --float<CR>", "Open parent directory")
end

function M.jdtls_debug()
  local jdtls = require("jdtls")
  map("n", "<leader>tm", jdtls.test_nearest_method, "Java: Test Nearest Method")
  map("n", "<leader>tc", jdtls.test_class, "Java: Test Class")
  map("n", "<leader>td", function() -- debug nearest test
    jdtls.test_nearest_method({ config = { noDebug = false } })
  end, "Java: Debug Nearest Method")
end

function M.dap()
  local dap = require("dap")
  local dapui = require("dapui")
  local dap_conf = require("config.dap")

  map("n", "<F5>", dap.continue, "DAP: Continue")
  map("n", "<F10>", dap.step_over, "DAP: Step Over")
  map("n", "<F11>", dap.step_into, "DAP: Step Into")
  map("n", "<F12>", dap.step_out, "DAP: Step Out")
  map("n", "<leader>b", dap.toggle_breakpoint, "DAP: Toggle Breakpoint")
  map("n", "<leader>B", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, "DAP: Conditional Breakpoint")
  map("n", "<leader>du", dapui.toggle, "DAP: Toggle UI")
  map("n", "<leader>de", dapui.eval, "DAP: Eval expression")
  map("n", "<leader>dr", dap.repl.open, "DAP: Open REPL")
  map("n", "<leader>dl", dap.run_last, "DAP: Run Last")
  map("n", "<leader>dx", dap.terminate, "DAP: Terminate")
  -- Override K only during a debug session
  dap.listeners.after.event_stopped["hover_keymap"] = function()
    vim.keymap.set("n", "K", function()
      require("dap.ui.widgets").hover()
    end, { buffer = true })
  end

  dap.listeners.after.event_terminated["hover_keymap"] = function()
    vim.keymap.del("n", "K", { buffer = true })
  end

  dap.listeners.after.event_exited["hover_keymap"] = function()
    vim.keymap.del("n", "K", { buffer = true })
  end
end

function M.lsp(bufnr)
  local function buf_map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
  end

  buf_map("n", "gd", vim.lsp.buf.definition, "Goto definition")
  buf_map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
  buf_map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
  buf_map("n", "gr", require('telescope.builtin').lsp_references, "Goto references")
  buf_map("n", "K", function()
    vim.lsp.buf.hover { border = 'rounded' }
  end, "Hover")
  buf_map("n", "<C-b>", function()
    vim.lsp.buf.signature_help { border = 'rounded' }
  end)
  buf_map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  buf_map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
  buf_map("n", "<leader>cf", function()
    require("conform").format({ async = true })
  end, "Format buffer")
  buf_map("n", "[d", function() vim.diagnostic.jump { count = -1, float = true } end, "Prev diagnostic")
  buf_map("n", "]d", function() vim.diagnostic.jump { count = 1, float = true } end, "Next diagnostic")
  buf_map("n", "<leader>ds", vim.diagnostic.open_float, "Line diagnostics")
  buf_map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace")
  buf_map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace")
  buf_map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List workspaces")
end

function M.coc(bufnr)
  local function buf_map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
  end

  buf_map("n", "gd", "<Plug>(coc-definition)", "Goto definition")
  buf_map("n", "gD", "<Plug>(coc-declaration)", "Goto declaration")
  buf_map("n", "gi", "<Plug>(coc-implementation)", "Goto implementation")
  buf_map("n", "gr", "<Plug>(coc-references)", "Goto references")
  buf_map("n", "K", function()
    local cw = vim.fn.expand("<cword>")
    if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
      vim.cmd("help " .. cw)
    elseif vim.api.nvim_eval("coc#rpc#ready()") then
      vim.fn.CocActionAsync("doHover")
    else
      vim.cmd("!" .. vim.o.keywordprg .. " " .. cw)
    end
  end, "Hover")
  buf_map("n", "<C-b>", "<Plug>(coc-float-scroll-down)", "Signature help / scroll float")
  buf_map("n", "<leader>rn", "<Plug>(coc-rename)", "Rename symbol")
  buf_map({ "n", "v" }, "<leader>ca", "<Plug>(coc-codeaction-cursor)", "Code action")
  buf_map("n", "<leader>cf", function()
    vim.fn.CocActionAsync("format")
  end, "Format buffer")
  buf_map("n", "[d", "<Plug>(coc-diagnostic-prev)", "Prev diagnostic")
  buf_map("n", "]d", "<Plug>(coc-diagnostic-next)", "Next diagnostic")
  buf_map("n", "<leader>ds", "<Plug>(coc-diagnostic-info)", "Line diagnostics")

  -- Insert-mode completion keys (buffer-local, replacing blink for these filetypes)
  vim.keymap.set("i", "<Tab>", function()
    if vim.fn["coc#pum#visible"]() == 1 then
      return vim.fn["coc#pum#next"](1)
    elseif vim.fn["coc#expandableOrJumpable"]() then
      return "<Plug>(coc-snippets-expand-jump)"
    end
    return "<Tab>"
  end, { buffer = bufnr, silent = true, expr = true, noremap = false })

  vim.keymap.set("i", "<S-Tab>", function()
    if vim.fn["coc#pum#visible"]() == 1 then
      return vim.fn["coc#pum#prev"](1)
    end
    return "<S-Tab>"
  end, { buffer = bufnr, silent = true, expr = true })

  vim.keymap.set("i", "<CR>",
    [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
    { buffer = bufnr, silent = true, expr = true, replace_keycodes = false })

  vim.keymap.set("i", "<C-Space>", "coc#refresh()", { buffer = bufnr, silent = true, expr = true })
end

return M
