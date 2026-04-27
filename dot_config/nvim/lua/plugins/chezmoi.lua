vim.pack.add {
    { src = 'https://github.com/xvzc/chezmoi.vim' },
    { src = 'https://github.com/xvzc/chezmoi.nvim' },
}

vim.g['chezmoi#use_tmp_buffer'] = true

require('chezmoi').setup {
    edit = {
        watch = true,
        force = false,
        ignore_patterns = {
            'run_onchange_.*',
            'run_once_.*',
            '%.chezmoiignore',
            '%.chezmoitemplate',
        },
    },
}

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { os.getenv 'HOME' .. '/.local/share/chezmoi/*' },
    callback = function(ev)
        local bufnr = ev.buf
        local edit_watch = function() require('chezmoi.commands.__edit').watch(bufnr) end
        vim.schedule(edit_watch)
    end,
})
