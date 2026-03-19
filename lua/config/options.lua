vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.incsearch = true
opt.hlsearch = false
opt.expandtab = true
opt.smartindent = true
opt.completeopt = { "menu", "menuone", "noselect" }
opt.updatetime = 250
opt.timeoutlen = 400
opt.list = true
opt.listchars = { trail = "·", tab = "» " }
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.fillchars = { eob = " " }

local undo_dir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undo_dir, "p")
opt.undofile = true
opt.undodir = undo_dir

vim.filetype.add({
  extension = {
    ll = "llvm",
    ino = "arduino"
  },
})

vim.g.vsnip_filetypes = {
  javascriptreact = { "javascript" },
  typescriptreact = { "typescript" },
}
