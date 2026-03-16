local M = {}

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

function M.setup()
  map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search")
  map("n", "<leader>pf", function()
    require("telescope.builtin").find_files()
  end, "Find files")
  map("n", "<leader>ps", function()
    require("telescope.builtin").live_grep()
  end, "Live grep")
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

  map('n', '<leader>st', ':7split | term<CR>', "Small Terminal")
  map('t', '<Esc>', [[<C-\><C-n>]])

  map("n", "<leader>qs", "<cmd>SessionSave<CR>", "Save session")
  map("n", "<leader>qr", "<cmd>SessionRestore<CR>", "Restore session")
  map("n", "<leader>qq", "<cmd>qa<CR>", "Quit Neovim")

  map("v", "<leader>y", '"+y', "Copy selection to clipboard")
  map("n", "<leader>Y", '<cmd>%y+<CR>', "Copy buffer to clipboard")

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

function M.jdtls_debug()
  local jdtls = require("jdtls")
  map("n","<leader>tm", jdtls.test_nearest_method, "Java: Test Nearest Method")
  map("n","<leader>tc", jdtls.test_class, "Java: Test Class")
  map("n","<leader>td", function()   -- debug nearest test
    jdtls.test_nearest_method({ config = { noDebug = false } })
  end, "Java: Debug Nearest Method")
end

function M.dap()
  local dap = require("dap")
  local dapui = require("dapui")

  map("n","<F5>", dap.continue, "DAP: Continue")
  map("n","<F10>", dap.step_over, "DAP: Step Over")
  map("n","<F11>", dap.step_into, "DAP: Step Into")
  map("n","<F12>", dap.step_out, "DAP: Step Out")
  map("n","<leader>b", dap.toggle_breakpoint, "DAP: Toggle Breakpoint")
  map("n","<leader>B", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, "DAP: Conditional Breakpoint")
  map("n","<leader>du", dapui.toggle, "DAP: Toggle UI")
  map("n","<leader>de", dapui.eval, "DAP: Eval expression")
  map("n","<leader>dr", dap.repl.open, "DAP: Open REPL")
  map("n","<leader>dl", dap.run_last, "DAP: Run Last")
  map("n","<leader>dx", dap.terminate, "DAP: Terminate")
end 

function M.lsp(bufnr)
  local function buf_map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
  end

  buf_map("n", "gd", vim.lsp.buf.definition, "Goto definition")
  buf_map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
  buf_map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
  buf_map("n", "gr", vim.lsp.buf.references, "Goto references")
  buf_map("n", "K", vim.lsp.buf.hover, "Hover")
  buf_map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  buf_map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
  buf_map("n", "<leader>cf", function()
    vim.lsp.buf.format({ async = true })
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
