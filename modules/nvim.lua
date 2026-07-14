-- requires: nvim-lspconfig
-- nvim-treesitter
-- snacks-nvim
-- as well as lsps
-- 
-- setings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "120"
vim.opt.showmatch = true
vim.opt.cmdheight = 1
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.showmode = false
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 0
vim.opt.conceallevel = 0
vim.opt.concealcursor = ""
vim.opt.lazyredraw = true
vim.opt.synmaxcol = 300
vim.opt.fillchars = { eob = " " }

local undodir = vim.fn.expand("~/.vim/undodir")
if
	vim.fn.isdirectory(undodir) == 0
then
	vim.fn.mkdir(undodir, "p")
end

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = undodir
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0
vim.opt.autoread = true
vim.opt.autowrite = false

vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.backspace = "indent,eol,start"
vim.opt.autochdir = false
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")
vim.opt.selection = "inclusive"
vim.opt.mouse = "a"
--vim.opt.clipboard:append("unnamedplus")
vim.opt.modifiable = true
vim.opt.encoding = "utf-8"

-- Folding: requires treesitter available at runtime; safe fallback if not
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.diffopt:append("linematch:60")
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

vim.opt.smoothscroll = true
vim.opt.grepprg = 'rg --vimgrep --no-messages --smart-case'
vim.opt.statusline = '[%n] %<%f %h%w%m%r%=%-14.(%l,%c%V%) %P'

-- interesting stugg

vim.cmd('syntax off') -- use treesitter

local map = vim.keymap.set

vim.api.nvim_create_autocmd('FileType', {
    callback = function() pcall(vim.treesitter.start) end,
})

-- I truely don't give a fuck enable what is installed
for _, config in ipairs(vim.lsp.get_configs()) do
    if type(config.name) == "string" and config.name ~= "*" then
        if config.cmd and type(config.cmd) == "table" then
            if config.cmd[1] and vim.fn.executable(config.cmd[1]) == 1 then
                vim.lsp.enable(config.name)
            end
        end
    end
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local buf = ev.buf
        local opts = { buffer = buf }

        vim.lsp.completion.enable(true, ev.data.client_id, buf, { autotrigger = true })
        -- Info / hover
        map('n', '<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, { desc = 'Toggle inlay hints' })
        map('n', 'K', vim.lsp.buf.hover, opts)

        map('n', '<C-k>', vim.lsp.buf.signature_help, opts)

        map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        map('n', '<leader>rn', vim.lsp.buf.rename, opts)

        map('n', '[d', vim.diagnostic.goto_prev, opts)
        map('n', ']d', vim.diagnostic.goto_next, opts)

        -- Format
        map('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
    end,
})


-- snacks.nvim
require('snacks').setup({
    explorer = {},
    picker = {
        layout = {
            preset = 'ivy',
            cycle = false,
        },
    },
})

-- Files
map('n', '<leader><space>', function() Snacks.picker.smart() end, { desc = 'Smart Find Files' })
map('n', '<leader>,',       function() Snacks.picker.buffers() end, { desc = 'Buffers' })
map('n', '<leader>/',       function() Snacks.picker.grep() end, { desc = 'Grep' })
map('n', '<leader>:',       function() Snacks.picker.command_history() end, { desc = 'Command History' })
map('n', '<leader>n',       function() Snacks.picker.notifications() end, { desc = 'Notification History' })
map('n', '<leader>e',       function() Snacks.explorer() end, { desc = 'File Explorer' })
map('n', '<leader>ff',      function() Snacks.picker.files() end, { desc = 'Find Files' })
map('n', '<leader>fg',      function() Snacks.picker.git_files() end, { desc = 'Find Git Files' })
map('n', '<leader>fp',      function() Snacks.picker.projects() end, { desc = 'Projects' })
map('n', '<leader>fr',      function() Snacks.picker.recent() end, { desc = 'Recent' })

-- Git
map('n', '<leader>gb',      function() Snacks.picker.git_branches() end, { desc = 'Git Branches' })
map('n', '<leader>gl',      function() Snacks.picker.git_log() end, { desc = 'Git Log' })
map('n', '<leader>gL',      function() Snacks.picker.git_log_line() end, { desc = 'Git Log Line' })
map('n', '<leader>gs',      function() Snacks.picker.git_status() end, { desc = 'Git Status' })
map('n', '<leader>gd',      function() Snacks.picker.git_diff() end, { desc = 'Git Diff (Hunks)' })
map('n', '<leader>gf',      function() Snacks.picker.git_log_file() end, { desc = 'Git Log File' })

-- Search
map('n', '<leader>sb',      function() Snacks.picker.lines() end, { desc = 'Buffer Lines' })
map('n', '<leader>sd',      function() Snacks.picker.diagnostics() end, { desc = 'Diagnostics' })
map('n', '<leader>sD',      function() Snacks.picker.diagnostics_buffer() end, { desc = 'Buffer Diagnostics' })
map('n', '<leader>sh',      function() Snacks.picker.help() end, { desc = 'Help Pages' })
map('n', '<leader>si',      function() Snacks.picker.icons() end, { desc = 'Icons' })
map('n', '<leader>sj',      function() Snacks.picker.jumps() end, { desc = 'Jumps' })
map('n', '<leader>sk',      function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
map('n', '<leader>sm',      function() Snacks.picker.marks() end, { desc = 'Marks' })
map('n', '<leader>sM',      function() Snacks.picker.man() end, { desc = 'Man Pages' })
map('n', '<leader>sq',      function() Snacks.picker.qflist() end, { desc = 'Quickfix List' })
map('n', '<leader>su',      function() Snacks.picker.undo() end, { desc = 'Undo History' })
map('n', '<leader>uC',      function() Snacks.picker.colorschemes() end, { desc = 'Colorschemes' })

-- LSP
map('n', 'gd',              function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
map('n', 'gD',              function() Snacks.picker.lsp_declarations() end, { desc = 'Goto Declaration' })
map('n', 'gr',              function() Snacks.picker.lsp_references() end, { desc = 'References', nowait = true })
map('n', 'gI',              function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })
map('n', 'gy',              function() Snacks.picker.lsp_type_definitions() end, { desc = 'Goto T[y]pe Definition' })
map('n', '<leader>ss',      function() Snacks.picker.lsp_symbols() end, { desc = 'LSP Symbols' })
map('n', '<leader>sS',      function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'LSP Workspace Symbols' })

-- theme
vim.cmd.colorscheme "oxocarbon"
-- default dark theme but with a 000 bg regardless of theme when in dark mode
-- fuck dark grey
local function apply_bg()
    if vim.o.background == 'dark' then
        vim.api.nvim_set_hl(0, 'Normal', { bg = '#000000' })
        vim.api.nvim_set_hl(0, 'NormalNC', { bg = '#000000' })
        vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#000000' })
        vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = '#000000' })
        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#000000' })
        vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#0a0a0a' })
        vim.api.nvim_set_hl(0, 'CursorColumn', { bg = '#0a0a0a' })
        vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = '#000000', fg = '#ffffff' })
        vim.api.nvim_set_hl(0, 'LineNr', { bg = '#000000' })
        vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#0a0a0a' })
        vim.api.nvim_set_hl(0, 'VertSplit', { bg = '#000000' })
        vim.api.nvim_set_hl(0, 'WinSeparator', { bg = '#000000' })
        vim.api.nvim_set_hl(0, 'FoldColumn', { bg = '#000000' })
        vim.api.nvim_set_hl(0, 'MsgArea', { bg = '#000000' })
        vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#000000' })
        vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = '#000000' })
        vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#000000' })
        vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = '#000000' })
        vim.api.nvim_set_hl(0, 'TabLine', { bg = '#000000' })
        vim.api.nvim_set_hl(0, 'TabLineFill', { bg = '#000000' })
    end
end


vim.api.nvim_create_autocmd('ColorScheme', { callback = apply_bg })

vim.api.nvim_create_autocmd('OptionSet', {
    pattern = 'background',
    callback = function()
        vim.schedule(apply_bg)
    end,
})

apply_bg()
