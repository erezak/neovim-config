-- set tabs
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")

vim.opt.cursorline = true

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<Up>', '<Nop>', {noremap = true, silent = true})
vim.keymap.set('n', '<Down>', '<Nop>', {noremap = true, silent = true})
vim.keymap.set('n', '<Left>', '<Nop>', {noremap = true, silent = true})
vim.keymap.set('n', '<Right>', '<Nop>', {noremap = true, silent = true})
-- and mouse
vim.opt.mouse = ""

-- set line numbers
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.termguicolors = true

vim.opt.conceallevel = 2
