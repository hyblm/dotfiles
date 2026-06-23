vim.pack.add({
  'https://github.com/echasnovski/mini.diff',
})

require('mini.diff').setup({
  view = {
    -- Keep the normal buffer clean; use overlay when you want the inline view.
    style = 'sign',
    signs = {
      add = '+',
      change = '~',
      delete = '-',
    },
  },
  mappings = {
    apply = '<leader>ha',
    reset = '<leader>hu',
    textobject = 'ih',
    goto_first = '[H',
    goto_prev = '[h',
    goto_next = ']h',
    goto_last = ']H',
  },
})

vim.keymap.set('n', '<leader>ho', function()
  require('mini.diff').toggle_overlay(0)
end, { desc = 'Toggle mini.diff overlay' })
