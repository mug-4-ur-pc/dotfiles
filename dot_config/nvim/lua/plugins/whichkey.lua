vim.pack.add {
    { src = 'https://github.com/folke/which-key.nvim' },
}

require('which-key').setup {
    preset = 'classic',
    delay = function(ctx) return ctx.plugin and 0 or 200 end,
    spec = {},
    triggers = {},
    win = {
        title = false,
        title_pos = 'center',
    },
}

vim.keymap.set(
    { 'n', 'i', 'v', 'x', 't', 'c' },
    '<C-/>',
    function() require('which-key').show { global = true } end,
    { silent = true, noremap = true, desc = 'Show WhichKey' }
)
-- Some terminals doesn't support 'C-/'
vim.keymap.set(
    { 'n', 'i', 'v', 'x', 't', 'c' },
    '<C-_>',
    function() require('which-key').show { global = true } end,
    { silent = true, noremap = true, desc = 'Show WhichKey' }
)
