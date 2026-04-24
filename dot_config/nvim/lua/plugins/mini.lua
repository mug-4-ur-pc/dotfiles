vim.pack.add {
    { src = 'https://github.com/nvim-mini/mini.nvim' },
}

require('mini.ai').setup()

require('mini.cmdline').setup()

require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()

require('mini.operators').setup()

require('mini.pairs').setup()

require('mini.splitjoin').setup()

require('mini.surround').setup {
    respect_selection_type = true,
}

require('mini.statusline').setup()
