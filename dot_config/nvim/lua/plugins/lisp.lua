vim.pack.add {
    { src = 'https://github.com/elkowar/yuck.vim' },
    { src = 'https://github.com/gpanders/nvim-parinfer' },
}

vim.filetype.add {
    extension = {
        yuck = 'yuck',
    },
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'yuck',
    callback = function()
        vim.bo.tabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.expandtab = true
        vim.cmd 'ParinferEnable'
    end,
})
