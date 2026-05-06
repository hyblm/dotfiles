vim.pack.add({
  'https://github.com/nvim-mini/mini.completion', -- Autocompletion
  'https://github.com/stevearc/quicker.nvim',     -- Enhanced quickfix/loclist
  'https://github.com/lewis6991/gitsigns.nvim',   -- Git integration
  'https://github.com/wtfox/jellybeans.nvim',     -- colorscheme
  'https://github.com/nvim-mini/mini.ai',
  'https://github.com/nvim-mini/mini.jump',
  'https://github.com/nvim-mini/mini.jump2d',
  'https://github.com/nvim-mini/mini.surround',
  'https://github.com/nvim-mini/mini.operators',
  'https://github.com/nvim-mini/mini.icons',
  'https://github.com/nvim-mini/mini.snippets',
  'https://github.com/ramojus/mellifluous.nvim'
})

require('mellifluous').setup {
  colorset = "kanagawa_dragon",
  transparent_background = {
    enabled = true,
    floating_windows = false,
    cursor_line = false,
    status_line = true,

  },
}
vim.cmd.colorscheme("mellifluous")

require('mini.completion').setup {}
require('mini.jump').setup {}
require('mini.jump2d').setup {}
require('mini.ai').setup {}
require('mini.surround').setup {}
require('mini.operators').setup {}
require('mini.icons').setup {}
require('mini.snippets').setup {}
require('quicker').setup {}
require('gitsigns').setup {}

require("hyblm.options")
require("hyblm.keymaps")
require('hyblm.task_runner')
require("hyblm.neovide")
require("hyblm.lsp")
require("hyblm.dap")
require("hyblm.ai")
