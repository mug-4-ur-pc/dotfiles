vim.pack.add {
    { src = 'https://github.com/mikavilpas/yazi.nvim' },
    { src = 'https://github.com/stevearc/oil.nvim' },
    { src = 'https://github.com/malewicz1337/oil-git.nvim' },
}

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
