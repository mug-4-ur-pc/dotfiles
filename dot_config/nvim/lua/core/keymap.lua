function set_map(mode, lhs, rhs, desc)
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

set_map({ 'n', 'v' }, '<leader>ef', '<cmd>Yazi<cr>', 'Open yazi at the current file')
set_map('n', '<leader>eF', '<cmd>Yazi cwd<cr>', "Open the file manager in nvim's working directory")
set_map('n', '<leader>ee', '<cmd>Yazi toggle<cr>', 'Resume the last yazi session')
set_map('n', '<leader>eo', '<cmd>Oil<cr>', 'Open oil file manager')

set_map('n', '<leader>f<space>', function() Snacks.picker.smart() end, 'Smart Find Files')
set_map('n', '<leader>:', function() Snacks.picker.command_history() end, 'Command History')
set_map('n', '<leader>n', function() Snacks.picker.notifications() end, 'Notifications')

set_map('n', '<leader>fgb', function() Snacks.picker.git_branches() end, 'Git Branches')
set_map('n', '<leader>fg', function() Snacks.picker.git_files() end, 'Find Git Files')
set_map('n', '<leader>fgl', function() Snacks.picker.git_log() end, 'Git Log')
set_map('n', '<leader>fgL', function() Snacks.picker.git_log_line() end, 'Git Log Line')
set_map('n', '<leader>fgs', function() Snacks.picker.git_status() end, 'Git Status')
set_map('n', '<leader>fgS', function() Snacks.picker.git_stash() end, 'Git Stash')
set_map('n', '<leader>fgd', function() Snacks.picker.git_diff() end, 'Git Diff')
set_map('n', '<leader>fgf', function() Snacks.picker.git_log_file() end, 'Git Log File')

set_map('n', '<leader>//', function() Snacks.picker.grep() end, 'Grep')
set_map('n', '<leader>/l', function() Snacks.picker.lines() end, 'Buffer Lines')
set_map('n', '<leader>/b', function() Snacks.picker.grep_buffers() end, 'Grep Open Buffers')
set_map('n', '<leader>/g', function() Snacks.picker.grep() end, 'Grep')
set_map('n', '<leader>/w', function() Snacks.picker.grep_word() end, 'Visual selection or word')

set_map('n', '<leader>f"', function() Snacks.picker.registers() end, 'Registers')
set_map('n', '<leader>f/', function() Snacks.picker.search_history() end, 'Search History')
set_map('n', '<leader>fa', function() Snacks.picker.autocmds() end, 'Autocmds')
set_map('n', '<leader>fb', function() Snacks.picker.buffers() end, 'Buffers')
set_map('n', '<leader>fc', function() Snacks.picker.command_history() end, 'Command History')
set_map('n', '<leader>fC', function() Snacks.picker.commands() end, 'Commands')
set_map('n', '<leader>fD', function() Snacks.picker.diagnostics() end, 'Diagnostics')
set_map('n', '<leader>fd', function() Snacks.picker.diagnostics_buffer() end, 'Buffer Diagnostics')
set_map('n', '<leader>fF', function() Snacks.picker.files { cwd = "~/" } end, 'Find Config File')
set_map('n', '<leader>ff', function() Snacks.picker.files() end, 'Find Files')
set_map('n', '<leader>fh', function() Snacks.picker.help() end, 'Help Pages')
set_map('n', '<leader>fH', function() Snacks.picker.highlights() end, 'Highlights')
set_map('n', '<leader>fi', function() Snacks.picker.icons() end, 'Icons')
set_map('n', '<leader>fj', function() Snacks.picker.jumps() end, 'Jumps')
set_map('n', '<leader>fk', function() Snacks.picker.keymaps() end, 'Keymaps')
set_map('n', '<leader>fl', function() Snacks.picker.loclist() end, 'Location List')
set_map('n', '<leader>fm', function() Snacks.picker.marks() end, 'Marks')
set_map('n', '<leader>fM', function() Snacks.picker.man() end, 'Man Pages')
set_map('n', '<leader>fp', function() Snacks.picker.projects() end, 'Projects')
set_map('n', '<leader>fq', function() Snacks.picker.qflist() end, 'Quickfix List')
set_map('n', '<leader>fr', function() Snacks.picker.resume() end, 'Resume')
set_map('n', '<leader>fu', function() Snacks.picker.undo() end, 'Undo History')
set_map('n', '<leader>f.', function() Snacks.picker.recent() end, 'Recent')
