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
    { src = 'https://github.com/nvim-telescope/telescope.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope-ui-select.nvim' },
    { src = 'https://github.com/mikavilpas/yazi.nvim' },
    { src = 'https://github.com/stevearc/oil.nvim' },
    { src = 'https://github.com/malewicz1337/oil-git.nvim' },
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

vim.api.nvim_create_autocmd('User', {
    pattern = 'OilActionsPost',
    callback = function(event)
        if event.data.actions[1].type == 'move' then Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url) end
    end,
})

local function parse_output(proc)
    local result = proc:wait()
    local ret = {}
    if result.code == 0 then
        for line in vim.gsplit(result.stdout, '\n', { plain = true, trimempty = true }) do
            -- Remove trailing slash
            line = line:gsub('/$', '')
            ret[line] = true
        end
    end
    return ret
end

-- build git status cache
local function new_git_status()
    return setmetatable({}, {
        __index = function(self, key)
            local ignore_proc = vim.system({ 'git', 'ls-files', '--ignored', '--exclude-standard', '--others', '--directory' }, {
                cwd = key,
                text = true,
            })
            local tracked_proc = vim.system({ 'git', 'ls-tree', 'HEAD', '--name-only' }, {
                cwd = key,
                text = true,
            })
            local ret = {
                ignored = parse_output(ignore_proc),
                tracked = parse_output(tracked_proc),
            }

            rawset(self, key, ret)
            return ret
        end,
    })
end
local git_status = new_git_status()

-- Clear git status cache on refresh
local refresh = require('oil.actions').refresh
local orig_refresh = refresh.callback
refresh.callback = function(...)
    git_status = new_git_status()
    orig_refresh(...)
end

require('yazi').setup {
    open_for_directories = false,
    open_multiple_tabs = true,
    change_neovim_cwd_on_close = false,
    floating_window_scaling_factor = 0.9,
    yazi_floating_window_winblend = 0,
    yazi_floating_window_border = 'rounded',
    yazi_floating_window_zindex = nil,
    keymaps = {
        show_help = '<f1>',
        open_file_in_vertical_split = '<c-v>',
        open_file_in_horizontal_split = '<h-x>',
        open_file_in_tab = '<c-t>',
        grep_in_directory = '<c-s>',
        replace_in_directory = '<c-g>',
        cycle_open_buffers = '<tab>',
        copy_relative_path_to_selected_files = '<c-y>',
        send_to_quickfix_list = '<c-q>',
        change_working_directory = '<c-\\>',
        open_and_pick_window = '<c-o>',
    },
    clipboard_register = '*',
    highlight_hovered_buffers_in_same_directory = true,
    integrations = {
        resolve_relative_path_implementation = function(args, get_relative_path)
            local cwd = vim.fn.getcwd()
            local path = get_relative_path {
                selected_file = args.selected_file,
                source_dir = cwd,
            }
            return path
        end,
    },
}

require('oil').setup {
    default_file_explorer = true,
    columns = {
        'icon',
    },
    delete_to_trash = false,
    skip_confirm_for_simple_edits = false,
    prompt_save_on_select_new_entry = true,
    cleanup_delay_ms = 2000,
    lsp_file_methods = {
        enabled = true,
        timeout_ms = 1000,
        autosave_changes = false,
    },
    constrain_cursor = 'editable',
    watch_for_changes = true,
    keymaps = {
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['<C-l>'] = 'actions.refresh',
        ['-'] = { 'actions.parent', mode = 'n' },
        ['_'] = { 'actions.open_cwd', mode = 'n' },
        ['`'] = { 'actions.cd', mode = 'n' },
        ['g~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['gx'] = 'actions.open_external',
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
        ['gi'] = {
            desc = 'Toggle file detailed info view',
            callback = function()
                detail = not detail
                if detail then
                    require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' }
                else
                    require('oil').set_columns { 'icon' }
                end
            end,
        },
    },
    view_options = {
        show_hidden = true,
        is_hidden_file = function(name, bufnr)
            local m = name:match '^%.'
            return m ~= nil
        end,
        is_always_hidden = function(name, bufnr)
            local dir = require('oil').get_current_dir(bufnr)
            if not dir then return false end
            return git_status[dir].ignored[name]
        end,
        natural_order = 'fast',
        case_insensitive = true,
        highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan) return nil end,
    },
    git = {
        -- Return true to automatically git add/mv/rm files
        add = function(path) return false end,
        mv = function(src_path, dest_path) return false end,
        rm = function(path) return false end,
    },
}
