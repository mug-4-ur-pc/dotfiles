vim.api.nvim_create_autocmd('PackChanged', {
    desc = 'Build telescope-fzf-native after install/update',
    group = vim.api.nvim_create_augroup('fzf_native_build', { clear = true }),
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
            vim.notify('Building telescope-fzf-native...', vim.log.levels.INFO)
            local obj = vim.system({ 'make' }, { cwd = ev.data.path }):wait()
            if obj.code == 0 then
                vim.notify('Building telescope-fzf-native done', vim.log.levels.INFO)
            else
                vim.notify('Building telescope-fzf-native failed', vim.log.levels.ERROR)
            end
        end
    end,
})

vim.pack.add {
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope-ui-select.nvim' },
}

local themes = require 'telescope.themes'

require('telescope').setup {
    pickers = {
        live_grep = {
            file_ignore_patterns = { 'node_modules', '.git' },
            additional_args = function(_) return { '--hidden' } end,
        },
        find_files = themes.get_ivy {
            layout_config = {
                height = 15, -- absolute: 15 rows
            },
            file_ignore_patterns = { 'node_modules', '.git' },
            hidden = true,
        },
        git_files = themes.get_ivy {
            layout_config = {
                height = 15, -- absolute: 15 rows
            },
        },
        help_tags = themes.get_ivy {
            layout_config = {
                height = 15, -- absolute: 15 rows
            },
        },
        man_pages = themes.get_ivy {
            layout_config = {
                height = 15, -- absolute: 15 rows
            },
        },
        keymaps = themes.get_ivy {
            layout_config = {
                height = 15, -- absolute: 15 rows
            },
        },
        diagnostics = themes.get_ivy {
            layout_config = {
                height = 15, -- absolute: 15 rows
            },
        },
        oldfiles = themes.get_ivy {
            layout_config = {
                height = 15, -- absolute: 15 rows
            },
        },
        buffers = themes.get_ivy {
            layout_config = {
                height = 15, -- absolute: 15 rows
            },
        },
        commands = {
            theme = 'dropdown',
        },
        command_history = {
            theme = 'dropdown',
        },
        marks = {
            theme = 'dropdown',
        },
        current_buffer_fuzzy_find = {
            theme = 'dropdown',
        },
    },
    extensions = {
        fzf = {},
        ['ui-select'] = { require('telescope.themes').get_dropdown() },
    },
}

pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Search help' })
vim.keymap.set('n', '<leader>fH', builtin.man_pages, { desc = 'Search help in man pages' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Search keymaps' })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Search files' })
vim.keymap.set('n', '<leader>fF', builtin.git_files, { desc = 'Search files in repo' })
vim.keymap.set('n', '<leader>f<cr>', builtin.builtin, { desc = 'Search select Telescope' })
vim.keymap.set({ 'n', 'v' }, '<leader>fw', builtin.grep_string, { desc = 'Search current word' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Search by grep' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Search diagnostics' })
vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = 'Search resume' })
vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = 'Search recent files ("." for repeat)' })
vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = 'Search commands' })
vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = 'Find marks' })
vim.keymap.set('n', '<leader>fq', builtin.quickfix, { desc = 'Search in quickfix list' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = '/ Fuzzily search in current buffer' })
vim.keymap.set(
    'n',
    '<leader>f/',
    function()
        builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
        }
    end,
    { desc = 'Search / in open files' }
)
vim.keymap.set('n', '<leader>fn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = 'Search Neovim files' })

vim.api.nvim_create_autocmd('User', {
    pattern = 'OilActionsPost',
    callback = function(event)
        if event.data.actions[1].type == 'move' then Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url) end
    end,
})
