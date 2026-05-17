vim.pack.add {
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
    { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
}

require('mason').setup()
require('mason-lspconfig').setup {}
require('mason-tool-installer').setup {
    ensure_installed = {
        'lua_ls',
        'stylua',
        'clangd',
        'golangci_lint_ls',
        'gopls',
        'goimports',
        'basedpyright',
        'ruff',
        'shfmt',
        'vtsls',
        'html',
        'cssls',
    },
    auto_update = false,
    run_on_start = true,
}

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('m4up-lsp-attach', { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc) vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc }) end

        map('gd', function() Snacks.picker.lsp_definitions() end, 'Goto Definition')
        map('gD', function() Snacks.picker.lsp_declarations() end, 'Goto Declaration')
        map('gR', function() Snacks.picker.lsp_references() end, 'References')
        map('gI', function() Snacks.picker.lsp_implementations() end, 'Goto Implementation')
        map('gt', function() Snacks.picker.lsp_type_definitions() end, 'Goto Type Definition')

        map('<leader>ls', function() Snacks.picker.lsp_symbols() end, 'LSP Symbols')
        map('<leader>lS', function() Snacks.picker.lsp_workspace_symbols() end, 'LSP Workspace Symbols')
        map('<leader>lr', vim.lsp.buf.rename, 'Rename symbol')
        map('<leader>la', vim.lsp.buf.code_action, 'Code action')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        map('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Workspace add Folder')
        map('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Workspace remove Folder')
        map('<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, 'Workspace list Folders')
    end,
})
