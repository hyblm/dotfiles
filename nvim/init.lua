vim.pack.add({
  'https://github.com/nvim-mini/mini.completion', -- Autocompletion
  'https://github.com/stevearc/quicker.nvim',     -- Enhanced quickfix/loclist
  'https://github.com/nvim-mini/mini.ai',
  'https://github.com/nvim-mini/mini.jump',
  'https://github.com/nvim-mini/mini.jump2d',
  'https://github.com/nvim-mini/mini.surround',
  'https://github.com/nvim-mini/mini.operators',
  'https://github.com/nvim-mini/mini.icons',
  'https://github.com/nvim-mini/mini.snippets',

  -- colorschemes
  'https://github.com/savq/melange-nvim',
  'https://github.com/wtfox/jellybeans.nvim',
  'https://github.com/ramojus/mellifluous.nvim',
  'https://github.com/oskarnurm/koda.nvim',
  'https://github.com/slugbyte/lackluster.nvim',
  'https://github.com/RockerBOO/boo-colorscheme-nvim',
  'https://github.com/zenbones-theme/zenbones.nvim',
  'https://github.com/rktjmp/lush.nvim',
})

require('mellifluous').setup {
  -- colorset = "mellifluous",
  -- colorset = "alduin",
  -- colorset = "mountain",
  -- colorset = "tender",
  colorset = "kanagawa_dragon",
  -- transparent_background = {
  --   enabled = true,
  --   floating_windows = false,
  --   cursor_line = false,
  --   status_line = true,
  -- },
}
vim.cmd.colorscheme("zenbones")

require('mini.completion').setup {}
require('mini.jump').setup {}
require('mini.jump2d').setup {}
require('mini.ai').setup {}
require('mini.surround').setup {}
require('mini.operators').setup {}
require('mini.icons').setup {}
-- require('mini.snippets').setup {}
require('quicker').setup {}

require("hyblm.options")
require("hyblm.keymaps")
require('hyblm.task_runner')
require("hyblm.neovide")
require("hyblm.lsp")
require("hyblm.dap")
require("hyblm.ai")
