vim.pack.add({ 'https://github.com/wincent/shannon' })

require('wincent.shannon').setup({
  keymaps = true,
  prefix = '<leader>i',
  agents = { 'pi' }
})
