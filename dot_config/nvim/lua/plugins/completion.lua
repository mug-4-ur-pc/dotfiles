vim.pack.add {
    { src = 'https://github.com/L3MON4D3/LuaSnip' },
    { src = 'https://github.com/Saghen/blink.cmp' },
    { src = 'https://github.com/rafamadriz/friendly-snippets' },
}

require('luasnip.loaders.from_vscode').lazy_load()

require('blink.cmp').setup {
    snippets = { preset = 'luasnip' },
    keymap = {
        preset = 'none',
        ['<C-n>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<S-Tab>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<Tab>'] = { 'accept', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<C-q>'] = { 'hide', 'fallback' },
        ['<C-y>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-e>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },
    completion = {
        menu = {
            auto_show = true,
            draw = {
                treesitter = { 'lsp' },
                columns = { { 'kind_icon', 'label', 'label_description', gap = 1 }, { 'kind' } },
            },
            border = 'none',
        },
        documentation = {
            auto_show = false,
            window = {
                border = 'none',
            },
        },
    },
    signature = {
        enabled = true,
        window = {
            border = 'none',
        },
    },
    fuzzy = { implementation = 'lua' },
    sources = {
        default = {
            'lsp',
            'snippets',
            'path',
        },
        per_filetype = {
            sql = { 'lsp', 'snippets' },
        },
        providers = {
            lsp = {
                score_offset = 90,
            },
        },
    },
}
