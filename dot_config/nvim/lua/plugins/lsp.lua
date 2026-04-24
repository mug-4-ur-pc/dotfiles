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
    },
    auto_update = false,
    run_on_start = true,
}

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('m4up-lsp-attach', { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc) vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc }) end

        map('gd', require('telescope.builtin').lsp_definitions, 'Goto definition')
        map('gR', require('telescope.builtin').lsp_references, 'Goto references')
        map('gI', require('telescope.builtin').lsp_implementations, 'Goto implementation')
        map('gt', require('telescope.builtin').lsp_type_definitions, 'Goto type definition')

        map('<leader>ls', require('telescope.builtin').lsp_document_symbols, 'Find symbols')
        map('<leader>lS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Find symbols in workspace')
        map('<leader>lr', vim.lsp.buf.rename, 'Rename symbol')
        map('<leader>la', vim.lsp.buf.code_action, 'Code action')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        map('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Workspace add Folder')
        map('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Workspace remove Folder')
        map('<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, 'Workspace list Folders')

        -- local client = vim.lsp.get_client_by_id(event.data.client_id)
        -- if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        --     local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        --     vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        --         buffer = event.buf,
        --         group = highlight_augroup,
        --         callback = vim.lsp.buf.document_highlight,
        --     })
        --
        --     vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        --         buffer = event.buf,
        --         group = highlight_augroup,
        --         callback = vim.lsp.buf.clear_references,
        --     })
        --
        --     vim.api.nvim_create_autocmd('LspDetach', {
        --         group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        --         callback = function(event2)
        --             vim.lsp.buf.clear_references()
        --             vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        --         end,
        --     })
        -- end
    end,
})
