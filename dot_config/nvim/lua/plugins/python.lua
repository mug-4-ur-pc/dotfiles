vim.pack.add {
    { src = 'https://github.com/linux-cultist/venv-selector.nvim.git' },
}

require('venv-selector').setup {
    settings = {
        options = {
            notify_user_on_venv_change = true,
        },
    },
}
