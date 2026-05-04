vim.pack.add {
    { src = 'https://github.com/folke/snacks.nvim' },
}

require('snacks').setup {
    animate = {
        enabled = true,
    },
    bigfile = {
        enabled = true,
        size = 32 * 1024 * 1024,
    },
    bufdelete = {
        enabled = true,
    },
    debug = {
        enabled = false,
    },
    git = {
        enabled = true,
    },
    gitbrowse = {
        enabled = true,
    },
    image = {
        enabled = true,
    },
    input = {
        enabled = true,
    },
    lazygit = {
        enabled = true,
        theme = {
            [241] = { fg = 'Special' },
            activeBorderColor = { fg = 'MatchParen', bold = true },
            cherryPickedCommitBgColor = { fg = 'Identifier' },
            cherryPickedCommitFgColor = { fg = 'Function' },
            defaultFgColor = { fg = 'Normal' },
            inactiveBorderColor = { fg = 'FloatBorder' },
            optionsTextColor = { fg = 'Function' },
            searchingActiveBorderColor = { fg = 'MatchParen', bold = true },
            selectedLineBgColor = { bg = 'PmenuSel' },
            unstagedChangesColor = { fg = 'DiagnosticError' },
        },
    },
    notifier = {
        enabled = true,
        timeout = 3000,
        padding = true,
        gap = 1,
        style = 'minimal',
        top_down = false,
    },
    picker = {
        enabled = true,
        prompt = '  ',
        focus = 'list',
        layout = {
            preset = 'ivy',
        },
        layouts = {
            ivy = {
                layout = {
                    box = 'vertical',
                    backdrop = false,
                    row = -1,
                    width = 0,
                    height = 0.5,
                    border = 'top',
                    title = ' {title} {live} {flags}',
                    title_pos = 'left',
                    { win = 'input', height = 1, border = 'bottom' },
                    {
                        box = 'horizontal',
                        { win = 'list', border = 'none' },
                        { win = 'preview', title = '{preview}', width = 0.5, border = 'left' },
                    },
                },
            },
            ivy_split = {
                layout = {
                    box = 'vertical',
                    backdrop = false,
                    width = 0,
                    height = 0.4,
                    position = 'bottom',
                    border = 'top',
                    title = ' {title} {live} {flags}',
                    title_pos = 'left',
                    { win = 'input', height = 1, border = 'bottom' },
                    {
                        box = 'horizontal',
                        { win = 'list', border = 'none' },
                        { win = 'preview', title = '{preview}', width = 0.6, border = 'left' },
                    },
                },
            },
            select = {
                layout = {
                    backdrop = false,
                    width = 0.5,
                    min_width = 80,
                    height = 0.4,
                    min_height = 10,
                    box = 'vertical',
                    border = 'rounded',
                    title = '{title}',
                    title_pos = 'center',
                    { win = 'input', height = 1, border = 'bottom' },
                    { win = 'list', border = 'none' },
                    { win = 'preview', height = 0.4, border = 'top' },
                },
            },
        },
        sources = {
            files = { layout = { preset = 'ivy_split' } },
            grep = { layout = { preset = 'ivy_split' } },
            buffers = { layout = { preset = 'ivy', preview = false } },
            recent = { layout = { preset = 'ivy' } },
            git_log = { layout = { preset = 'ivy_split' } },
            git_status = { layout = { preset = 'ivy_split' } },
            git_branches = { layout = { preset = 'select' } },
            git_stash = { layout = { preset = 'select' } },
            diagnostics = { layout = { preset = 'ivy_split' } },
            diagnostics_buffer = { layout = { preset = 'ivy' } },
            lsp_definitions = { layout = { preset = 'ivy_split' } },
            lsp_references = { layout = { preset = 'ivy_split' } },
            lsp_implementations = { layout = { preset = 'ivy_split' } },
            lsp_type_definitions = { layout = { preset = 'ivy_split' } },
            lsp_symbols = { layout = { preset = 'ivy' } },
            lsp_workspace_symbols = { layout = { preset = 'ivy_split' } },
            keymaps = { layout = { preset = 'select' } },
            commands = { layout = { preset = 'select' } },
            command_history = { layout = { preset = 'ivy' } },
            search_history = { layout = { preset = 'ivy' } },
            marks = { layout = { preset = 'ivy' } },
            jumps = { layout = { preset = 'ivy' } },
            registers = { layout = { preset = 'select' } },
            colorschemes = { layout = { preset = 'select' } },
            undo = { layout = { preset = 'ivy_split' } },
            projects = { layout = { preset = 'ivy' } },
            help = { layout = { preset = 'ivy_split' } },
            man = { layout = { preset = 'ivy_split' } },
            lazy = { layout = { preset = 'ivy' } },
            lines = { layout = { preset = 'ivy' } },
            grep_buffers = { layout = { preset = 'ivy' } },
            loclist = { layout = { preset = 'ivy' } },
            qflist = { layout = { preset = 'ivy' } },
            autocmds = { layout = { preset = 'ivy' } },
            highlights = { layout = { preset = 'ivy' } },
            icons = { layout = { preset = 'select' } },
        },
        win = {
            input = {
                keys = {
                    ['<C-e>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
                    ['<C-y>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
                    ['<C-h>'] = { 'edit_split', mode = { 'i', 'n' } },
                    ['<C-v>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
                    ['<C-t>'] = { 'edit_tab', mode = { 'i', 'n' } },
                },
            },
            list = {
                keys = {
                    ['<CR>'] = 'confirm',
                    ['<2-LeftMouse>'] = 'confirm',
                    ['<C-h>'] = 'edit_split',
                    ['<C-v>'] = 'edit_vsplit',
                    ['<C-t>'] = 'edit_tab',
                    ['<C-e>'] = 'preview_scroll_down',
                    ['<C-y>'] = 'preview_scroll_up',
                },
            },
        },
        matcher = {
            cwd_bonus = true,
            frecency = true,
        },
    },
    scratch = {
        win_by_ft = {
            lua = {
                keys = {
                    ['source'] = {
                        '<cr>',
                        function(self)
                            local name = 'scratch.' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ':e')
                            Snacks.debug.run { buf = self.buf, name = name }
                        end,
                        desc = 'Source buffer',
                        mode = { 'n', 'x' },
                    },
                },
            },
        },
    },
    scroll = {
        enabled = true,
    },
    toggle = {
        enabled = true,
    },
    words = {
        enabled = true,
    },
    zen = {
        enabled = true,
        toggles = {
            blink_indent = false,
            dim = false,
            inlay_hints = false,
            line_number = false,
            words = false,
        },
    },
}

local progress = vim.defaulttable()
vim.api.nvim_create_autocmd('LspProgress', {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
        if not client or type(value) ~= 'table' then return end
        local p = progress[client.id]

        for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
                p[i] = {
                    token = ev.data.params.token,
                    msg = ('[%3d%%] %s%s'):format(
                        value.kind == 'end' and 100 or value.percentage or 100,
                        value.title or '',
                        value.message and (' **%s**'):format(value.message) or ''
                    ),
                    done = value.kind == 'end',
                }
                break
            end
        end

        local msg = {} ---@type string[]
        progress[client.id] = vim.tbl_filter(function(v) return table.insert(msg, v.msg) or not v.done end, p)

        local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
        vim.notify(table.concat(msg, '\n'), 'info', {
            id = 'lsp_progress',
            title = client.name,
            opts = function(notif) notif.icon = #progress[client.id] == 0 and ' ' or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1] end,
        })
    end,
})

Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>ow'
Snacks.toggle.option('relativenumber', { name = 'Relative line numbers' }):map '<leader>or'
Snacks.toggle
    .option('conceallevel', {
        off = 0,
        on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
        name = 'Conceal',
    })
    :map '<leader>oc'

Snacks.toggle({
    name = 'Buffer Autoformat',
    get = function() return not vim.b.disable_autoformat end,
    set = function(state) vim.b.disable_autoformat = not state end,
}):map '<leader>of'

Snacks.toggle({
    name = 'Global Autoformat',
    get = function() return not vim.g.disable_autoformat end,
    set = function(state) vim.g.disable_autoformat = not state end,
}):map '<leader>oF'

Snacks.toggle.diagnostics():map '<leader>oD'
Snacks.toggle.dim():map '<leader>od'
Snacks.toggle.inlay_hints():map '<leader>oh'
Snacks.toggle.line_number():map '<leader>on'
Snacks.toggle.treesitter():map '<leader>oT'
Snacks.toggle.words():map '<leader>oW'
Snacks.toggle.zen():map '<leader>oz'
Snacks.toggle.zoom():map '<leader>oZ'

local blink_indent_toggle = Snacks.toggle.new {
    id = 'blink_indent',
    name = 'Indent Guides',
    get = function() return require('blink.indent').is_enabled() end,
    set = function(state) require('blink.indent').enable(state) end,
}
blink_indent_toggle:map '<leader>oi'
