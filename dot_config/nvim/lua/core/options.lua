vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.g.have_nerd_font = true

vim.opt.termguicolors = true
vim.opt.mouse = 'a'

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'
vim.o.numberwidth = 3

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.o.autoread = true

vim.opt.wrap = false
vim.opt.linebreak = true
--vim.opt.whichwrap = 'bs<>[]hl'

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.breakindent = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.cmdheight = 0
vim.o.laststatus = 3
vim.opt.showtabline = 1
vim.opt.pumheight = 10

vim.opt.updatetime = 250
vim.opt.timeoutlen = 1000

vim.opt.splitright = true
vim.opt.splitbelow = false

vim.opt.scrolloff = 7
vim.opt.sidescrolloff = 8

vim.o.fileencoding = 'utf-8'

vim.opt.inccommand = 'split'

vim.opt.winborder = 'single'

vim.opt.hlsearch = true
vim.o.incsearch = true

vim.opt.completeopt = 'menu,menuone,noselect,preview'

vim.opt.backspace = 'indent,eol,start'

vim.opt.conceallevel = 2

vim.opt.shortmess:append 'c'
vim.opt.formatoptions:remove { 'c', 'o' }

vim.opt.runtimepath:remove '/usr/share/vim/vimfiles'

vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

vim.opt.fillchars = { eob = ' ' }

vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', scope = 'cursor', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    virtual_text = true,
    virtual_lines = false,
    jump = { float = false, wrap = true },
}
