vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/NeogitOrg/neogit',
})

local diffview_actions = require('diffview.actions')

require('diffview').setup({
  enhanced_diff_hl = true,
  show_help_hints = false,
  use_icons = false,
  signs = {
    fold_closed = '▸',
    fold_open = '▾',
    done = '✓',
  },
  view = {
    default = {
      layout = 'diff2_horizontal',
      disable_diagnostics = true,
      winbar_info = true,
    },
    merge_tool = {
      layout = 'diff3_mixed',
      disable_diagnostics = true,
      winbar_info = true,
    },
    file_history = {
      layout = 'diff2_horizontal',
      disable_diagnostics = true,
      winbar_info = true,
    },
  },
  file_panel = {
    listing_style = 'list',
    win_config = {
      position = 'bottom',
      height = 10,
      win_opts = {
        winhl = 'Normal:Normal,EndOfBuffer:EndOfBuffer',
      },
    },
  },
  file_history_panel = {
    win_config = {
      position = 'bottom',
      height = 12,
      win_opts = {
        winhl = 'Normal:Normal,EndOfBuffer:EndOfBuffer',
      },
    },
  },
  keymaps = {
    view = {
      { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' } },
      { 'n', '<leader>e', diffview_actions.toggle_files, { desc = 'Toggle file panel' } },
    },
    file_panel = {
      { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' } },
      { 'n', '<leader>e', diffview_actions.toggle_files, { desc = 'Toggle file panel' } },
    },
    file_history_panel = {
      { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' } },
      { 'n', '<leader>e', diffview_actions.toggle_files, { desc = 'Toggle file panel' } },
    },
  },
})

require('neogit').setup({
  integrations = {
    diffview = true,
  },
})

vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'Open Neogit status' })
vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Open Diffview' })
vim.keymap.set('n', '<leader>gD', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'Current file Git history' })
vim.keymap.set('n', '<leader>gH', '<cmd>DiffviewFileHistory<cr>', { desc = 'Git history' })
