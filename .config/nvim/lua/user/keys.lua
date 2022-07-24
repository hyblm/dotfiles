-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighLight', {clear=true})
	vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
--
-- Telescope
vim.keymap.set( 'n', ' fd', require 'telescope.builtin'.find_files )
vim.keymap.set( 'n', ' /', function()
	require 'telescope.builtin'.current_buffer_fuzzy_find(require('telescope.themes').get_ivy {} )
end, {desc = '[/] Fuzzy find in current buffer' })

-- move back and forward in the quickfix list
vim.keymap.set( 'n', '<C-j>', '<cmd>cnext<cr>' )
vim.keymap.set( 'n', '<C-k>', '<cmd>cprevious<cr>' )
