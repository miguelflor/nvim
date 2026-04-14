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
  map("n", "<leader>ps", lsp_root_run("live_grep"), "Live grep")
  map("n", "<leader>fb", function()
    require("telescope.builtin").buffers()
  end, "List buffers")
  map("n", "<leader>fh", function()
    require("telescope.builtin").help_tags()
  end, "Help tags")
  map("n", "<leader>fd", function()
    require("telescope").extensions.projects.projects()
  end, "Projects")
  map("n", "<leader>fe", function()
    require("telescope.builtin").diagnostics()
  end, "Workspace diagnostics")

  map("n", "<leader>e", function()
    require("nvim-tree.api").tree.toggle({ focus = true })
  end, "Toggle tree")

  map("v", "<A-j>", ":m '>+1<CR>gv=gv", "Move up");
  map("v", "<A-k>", ":m '<-2<CR>gv=gv", "Mode down");
  map("n", "<A-j>", ":m .+1<CR>==", "Move line down")
  map("n", "<A-k>", ":m .-2<CR>==", "Move line up")

  map("n", "<leader>td", "<cmd>TodoTelescope<CR>", "List TODOs")
  map("n", "<leader>u", "<cmd>UndotreeToggle<CR>", "Toggle undotree")
  map("n", "<leader>gs", "<cmd>Git<CR>", "Fugitive status")

  map("n", "<leader>bn", "<cmd>bnext<CR>", "Next buffer")
  map("n", "<leader>bp", "<cmd>bprevious<CR>", "Prev buffer")
  map("n", "<leader>bd", "<cmd>bdelete<CR>", "Close buffer")

  map("n", "<C-h>", "<C-w>h", "Focus window left")
  map("n", "<C-j>", "<C-w>j", "Focus window below")
  map("n", "<C-k>", "<C-w>k", "Focus window above")
  map("n", "<C-l>", "<C-w>l", "Focus window right")

  map("n", "<leader>qs", "<cmd>SessionSave<CR>", "Save session")
  map("n", "<leader>qr", "<cmd>SessionRestore<CR>", "Restore session")
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
end

function M.kulala()
  map("n", "<leader>Rs", function() require("kulala").run() end, "Send request")
  map("n", "<leader>Ra", function() require("kulala").run_all() end, "Send all requests")
  map("n", "<leader>Rb", function() require("kulala").scratchpad() end, "Open scratchpad")
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
  map("n", "<leader>dv", dap_conf.dap_expand_to_buffer, "DAP: View in Buffer")
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
  buf_map("n", "<leader>lr", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
      vim.lsp.stop_client(client.id)
    end
    vim.defer_fn(function()
      vim.cmd("edit")
    end, 500) -- small delay to let the client fully stop before reattaching
  end, "Restart LSP")

  buf_map("n", "gd", vim.lsp.buf.definition, "Goto definition")
  buf_map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
  buf_map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
  buf_map("n", "gr", require('telescope.builtin').lsp_references, "Goto references")
  buf_map("n", "K", vim.lsp.buf.hover, "Hover")
  buf_map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  buf_map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
  buf_map("n", "<leader>cf", function()
    require("conform").format({ async = true, lsp_fallback = true })
  end, "Format buffer")
  buf_map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
  buf_map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
  buf_map("n", "<leader>ds", vim.diagnostic.open_float, "Line diagnostics")
  buf_map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace")
  buf_map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace")
  buf_map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List workspaces")
end

return M
