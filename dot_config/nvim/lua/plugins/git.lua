vim.pack.add {
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
}

require('gitsigns').setup {
    numhl = true,
    on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, desc)
            local opts = {
                buffer = bufnr,
                silent = true,
                noremap = true,
                desc = desc,
            }
            vim.keymap.set(mode, l, r, opts)
        end

        map('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal { ']c', bang = true }
            else
                gitsigns.nav_hunk 'next'
            end
        end, 'Jump to next git change')

        map('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal { '[c', bang = true }
            else
                gitsigns.nav_hunk 'prev'
            end
        end, 'Jump to previous git change')

        map('v', '<leader>gs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Git stage hunk')
        map('v', '<leader>gr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Git reset hunk')

        map('n', '<leader>gs', gitsigns.stage_hunk, 'Git stage hunk')
        map('n', '<leader>gr', gitsigns.reset_hunk, 'Git reset hunk')
        map('n', '<leader>gS', gitsigns.stage_buffer, 'Git stage buffer')
        map('n', '<leader>gR', gitsigns.reset_buffer, 'Git reset buffer')
        map('n', '<leader>gP', gitsigns.preview_hunk, 'Git preview hunk')
        map('n', '<leader>gp', gitsigns.preview_hunk_inline, 'Git preview hunk inline')
        map('n', '<leader>gb', function() gitsigns.blame_line { full = true } end, 'Git blame line')
        map('n', '<leader>gB', function() Snacks.git.blame_line() end, 'Show git blame')
        map('n', '<leader>gd', gitsigns.diffthis, 'Git diff against index')
        map('n', '<leader>gD', function() gitsigns.diffthis '@' end, 'Git diff against last commit')
        map('n', '<leader>gQ', function() gitsigns.setqflist 'all' end, 'Git hunk quickfix list (all files in repo)')
        map('n', '<leader>gq', gitsigns.setqflist, 'Git hunk quickfix list (all changes in this file)')
        map('n', '<leader>gx', function() Snacks.gitbrowse.open() end, 'Open git commit of current file')

        map('n', '<leader>ogb', gitsigns.toggle_current_line_blame, 'Toggle git show blame line')
        map('n', '<leader>ogw', gitsigns.toggle_word_diff, 'Toggle git intra-line word diff')
        map('n', '<leader>ogs', gitsigns.toggle_signs, 'Toggle git signs')
        map('n', '<leader>ogl', gitsigns.toggle_linehl, 'Toggle git line highlight')
        map('n', '<leader>ogn', gitsigns.toggle_numhl, 'Toggle git line numbers highlight')

        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
    end,
}
