vim.pack.add({
    { src = 'https://github.com/mrjones2014/smart-splits.nvim' }
})

local smart_splits = require 'smart-splits'
smart_splits.setup({
    -- Ignored buffer types (only while resizing)
    ignored_buftypes = {
        'nofile',
        'quickfix',
        'prompt',
    },
    -- Ignored filetypes (only while resizing)
    ignored_filetypes = { 'NvimTree' },
    default_amount = 3,
    at_edge = 'stop',
    float_win_behavior = 'previous',
    move_cursor_same_row = false,
    cursor_follows_swapped_bufs = true,
    disable_multiplexer_nav_when_zoomed = true,
    zellij_move_focus_or_tab = true,
    log_level = 'warn',
})

-- Resizing splits
vim.keymap.set('n', '<M-h>', smart_splits.resize_left, { silent = true, noremap = true, desc = 'Resize split left' })
vim.keymap.set('n', '<M-j>', smart_splits.resize_down, { silent = true, noremap = true, desc = 'Resize split down' })
vim.keymap.set('n', '<M-k>', smart_splits.resize_up, { silent = true, noremap = true, desc = 'Resize split up' })
vim.keymap.set('n', '<M-l>', smart_splits.resize_right, { silent = true, noremap = true, desc = 'Resize split right' })
-- Moving between splits
vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left, { silent = true, noremap = true, desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down, { silent = true, noremap = true, desc = 'Move to below split' })
vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up, { silent = true, noremap = true, desc = 'Move to above split' })
vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right, { silent = true, noremap = true, desc = 'Move to right split' })
vim.keymap.set('n', '<C-\\>', smart_splits.move_cursor_previous, { silent = true, noremap = true, desc = 'Move to previous split' })
-- Swapping buffers between windows
vim.keymap.set('n', '<leader><leader>h', smart_splits.swap_buf_left, { silent = true, noremap = true, desc = 'Swap buffer left' })
vim.keymap.set('n', '<leader><leader>j', smart_splits.swap_buf_down, { silent = true, noremap = true, desc = 'Swap buffer down' })
vim.keymap.set('n', '<leader><leader>k', smart_splits.swap_buf_up, { silent = true, noremap = true, desc = 'Swap buffer up' })
vim.keymap.set('n', '<leader><leader>l', smart_splits.swap_buf_right, { silent = true, noremap = true, desc = 'Swap buffer right' })
