-- KEYMAPS
--
-- See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`
-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')

-- inspired by Greg Hurrell Vim screencast #2: folding https://youtu.be/oqYQ7IeDs0E?si=4hi3_yeqi-vdpLGB
vim.keymap.set({ 'n' }, '<S-Tab>', 'za')

local function qf_next()
  if not pcall(vim.cmd.cnext) then
    vim.cmd.cfirst()
  end
end

local function qf_prev()
  if not pcall(vim.cmd.cprevious) then
    vim.cmd.clast()
  end
end

vim.keymap.set({ 'n' }, ']q', qf_next, { desc = 'Next quickfix item, wrapping' })
vim.keymap.set({ 'n' }, '[q', qf_prev, { desc = 'Previous quickfix item, wrapping' })
vim.keymap.set({ 'n' }, '<M-n>', qf_next, { desc = 'Next quickfix item, wrapping' })
vim.keymap.set({ 'n' }, '<M-p>', qf_prev, { desc = 'Previous quickfix item, wrapping' })

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- HELIX compat
vim.keymap.set('n', 'gh', '^')
vim.keymap.set('n', 'gn', ':bnext<CR>')
vim.keymap.set('n', 'gp', ':bprev<CR>')
vim.keymap.set('n', 'gl', '$')
vim.keymap.set('n', 'ge', 'G')
vim.keymap.set('n', '<leader>c', 'gcc', { remap = true, desc = "Comment line" })
vim.keymap.set('n', '<M-c>', 'gcc', { remap = true, desc = "Comment line" })
vim.keymap.set('n', 'ga', '<C-^>')
vim.keymap.set('n', '<C-A-h>', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
