vim.pack.add({ 'https://github.com/ibhagwan/fzf-lua' })

local fzflua = require('fzf-lua')

fzflua.setup { fzf_colors = true }

-- HELIX compat
vim.keymap.set('n', '<leader>f', function() fzflua.files({}) end)
vim.keymap.set('n', '<leader>b', function() fzflua.buffers({}) end)
vim.keymap.set('n', '<leader>j', function() fzflua.jumps({}) end)
vim.keymap.set('n', '<leader>g', function() fzflua.changes({}) end)
vim.keymap.set('n', '<leader>s', function() fzflua.lsp_document_symbols({}) end)
vim.keymap.set('n', '<leader>S', function() fzflua.lsp_workspace_symbols({}) end)
vim.keymap.set('n', '<leader>R', function() fzflua.lsp_references({}) end)
vim.keymap.set('n', '<leader>d', function() fzflua.diagnostics_document({}) end)
vim.keymap.set('n', '<leader>D', function() fzflua.diagnostics_workspace({}) end)

vim.keymap.set('n', '<leader>z', function() fzflua.zoxide({}) end)
vim.keymap.set('n', '<leader>h', function() fzflua.helptags({}) end)
vim.keymap.set('n', '<leader>/', function() fzflua.live_grep({}) end)
vim.keymap.set('n', '<leader><leader><leader>', function() fzflua.builtin({}) end)
