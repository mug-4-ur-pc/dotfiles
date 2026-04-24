vim.pack.add {
    { src = 'https://github.com/saghen/blink.indent' },
    { src = 'https://github.com/catgoose/nvim-colorizer.lua' },
}

require('blink.indent').setup {
    mappings = {
        border = 'both',
        object_scope = 'ii',
        object_scope_with_border = 'ai',
        goto_top = '[i',
        goto_bottom = ']i',
    },
    static = {
        enabled = true,
        char = '│',
        priority = 1,
        highlights = { 'Indent' },
    },
    scope = {
        enabled = true,
        char = '│',
        priority = 1000,
        highlights = { 'IndentScope' },
        underline = {
            enabled = false,
        },
    },
}

require('colorizer').setup {
    filetypes = {
        '*',
        css = {
            options = {
                parsers = {
                    css = true,
                },
            },
        },
    },
    options = {
        parsers = {
            names = { enable = false },
            css = false,
        },
    },
}
