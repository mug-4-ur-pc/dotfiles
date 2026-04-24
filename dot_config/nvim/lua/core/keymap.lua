local function set_map(mode, lhs, rhs, desc)
    local opts = { silent = true, noremap = true }
    if desc then opts.desc = desc end
    vim.keymap.set(mode, lhs, rhs, opts)
end

vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

set_map('n', '<Esc>', '<cmd>nohlsearch<CR>', 'Hide search highlights')

set_map('n', '<leader>sn', '<cmd>noautocmd w <CR>', 'Save without autoformatting')

set_map('n', 'x', '"_x', 'Delete character under cursor')
set_map('n', 'X', '"_X', 'Delete character before cursor')
set_map('n', 'n', 'nzzzv', 'Next search result centered')
set_map('n', 'N', 'Nzzzv', 'Previous search result centered')

set_map('n', '<C-d>', '<C-d>zz', 'Scroll down and center cursor')
set_map('n', '<C-u>', '<C-u>zz', 'Scroll up and center cursor')

-- Window management
set_map('n', '<leader>wv', '<C-w>v', 'Split window vertically')
set_map('n', '<leader>wh', '<C-w>s', 'Split window horizontally')
set_map('n', '<leader>w=', '<C-w>=', 'Make split windows equal width & height')
set_map('n', '<leader>wq', ':close<CR>', 'Close current split window')

-- Buffers
set_map('n', '<leader>bn', ':bnext<CR>', 'Next buffer')
set_map('n', '<leader>bp', ':bprevious<CR>', 'Previous buffer')
set_map('n', '<leader>bb', '<C-i>')
set_map('n', '<leader>bq', function() require('snacks').bufdelete.delete() end, 'Close buffer')
set_map('n', '<leader>bQ', function() require('snacks').bufdelete.all() end, 'Close all buffers')
set_map('n', '<leader>bc', ':enew <CR>', 'New buffer')

-- Tabs
set_map('n', '<leader>tc', ':tabnew<CR>', 'Open new tab')
set_map('n', '<leader>tq', ':tabclose<CR>', 'Close current tab')
set_map('n', '<leader>tn', ':tabn<CR>', 'Go to next tab')
set_map('n', '<leader>tp', ':tabp<CR>', 'Go to previous tab')

set_map('t', '<Esc><Esc>', '<C-\\><C-n>', 'Exit terminal mode')

-- Increment/decrement numbers
set_map('n', '<leader>+', '<C-a>')
set_map('n', '<leader>-', '<C-x>')

-- Stay in indent mode
set_map('v', '<', '<gv', 'Decrease indent')
set_map('v', '>', '>gv', 'Increase indent')

-- Move text up and down
set_map('v', '<A-j>', ':m .+2<CR>==gv', 'Move selected text donw')
set_map('v', '<A-k>', ':m .-2<CR>==gv', ' Move selected text up')

set_map('n', '<leader>lf', function() require('conform').format { async = true, lsp_format = 'fallback' } end, 'Format file')

-- Clipboard copy/paste
set_map({ 'n', 'v' }, '<leader>d', '"+d')
set_map({ 'n', 'v' }, '<leader>y', '"+y')

-- Keep last yanked when pasting
set_map('v', 'p', '"_dp')

set_map('n', '<leader>ld', vim.diagnostic.setloclist, 'Open diagnostic quickfix list')
set_map('n', '<leader>J', vim.diagnostic.open_float, 'Open floating diagnostic message')

set_map('n', '<leader>nh', function() Snacks.notifier.show_history() end, 'Open git log for current file')
set_map('n', '<leader>.', function() Snacks.scratch() end, 'Toggle scratch buffer')
set_map('n', '<leader>fs', function() Snacks.scratch.select() end, 'Select scratch buffer')
set_map('n', '<leader>gg', function() Snacks.lazygit.open() end, 'Open lazygit')
set_map('n', '<leader>gl', function() Snacks.lazygit.log() end, 'Open git log')
set_map('n', '<leader>gL', function() Snacks.lazygit.log_file() end, 'Open git log for current file')

set_map(
    'n',
    '<leader>ce',
    function()
        require('chezmoi.commands').edit {
            targets = { vim.fn.expand '%:p' },
            args = { '--watch' },
        }
    end,
    'Chezmoi: Edit source of current file'
)

set_map(
    'n',
    '<leader>ca',
    function()
        require('chezmoi.commands').apply {
            targets = { vim.fn.expand '%:p' },
        }
    end,
    'Chezmoi: Apply current file'
)

set_map('n', '<leader>cA', function() require('chezmoi.commands').apply {} end, 'Chezmoi: Apply all')

set_map('n', '<leader>fC', function() require('chezmoi.pick').snacks() end, 'Find config file')

set_map(
    'n',
    '<leader>fn',
    function()
        require('chezmoi.pick').snacks(vim.fn.stdpath 'config', {
            '--path-style',
            'absolute',
            '--include',
            'files',
            '--exclude',
            'externals',
        })
    end,
    'Open nvim config'
)
