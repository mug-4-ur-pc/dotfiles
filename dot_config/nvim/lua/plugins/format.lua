vim.pack.add({
    { src = 'https://github.com/nmac427/guess-indent.nvim' },
    { src = 'https://github.com/stevearc/conform.nvim' }
})

require("conform").setup({
    formatters_by_ft = {
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },

        c = { 'clang_format' },
        cpp = { 'clang_format' },
        cuda = { 'clang_format' },

        go = { 'goimports', 'gofumpt' },

        lua = { 'stylua' },

        python = { 'ruff_organize_imports', 'ruff_format' },

        markdown = { 'injected' },

        ['*'] = { 'trim_newlines', 'trim_whitespace' },
    },
    formatters = {
        shfmt = {
            prepend_args = { '-i', '4', '-ci' },
        },
        sqlfluff = {
            args = { 'format', '--dialect=postgres', '-' },
        },
        yamlfmt = {
            args = { '-formatter', 'retain_line_breaks=true', '-in' },
        },
        prettier = {
            prepend_args = { '--prose-wrap', 'always' },
        },
        injected = {
            options = {
                ignore_errors = true,
                lang_to_formatters = {
                    sh = { 'shfmt' },
                    bash = { 'shfmt' },
                    zsh = { 'shfmt' },
                    go = { 'gofumpt' },
                    python = { 'ruff_format' },
                },
            },
        },
    },
    format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 800, lsp_format = 'fallback' }
    end,
    notify_on_error = true,
})

require("guess-indent").setup()
