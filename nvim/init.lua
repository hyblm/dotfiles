vim.pack.add({
  "https://github.com/stevearc/quicker.nvim", -- Enhanced quickfix/loclist

  "https://github.com/nvim-mini/mini.completion",
  "https://github.com/nvim-mini/mini.ai",
  "https://github.com/nvim-mini/mini.jump",
  "https://github.com/nvim-mini/mini.jump2d",
  "https://github.com/nvim-mini/mini.surround",
  "https://github.com/nvim-mini/mini.operators",
  "https://github.com/nvim-mini/mini.icons",

  -- Colorscheme
  "https://github.com/zenbones-theme/zenbones.nvim",
  "https://github.com/rktjmp/lush.nvim",
})

vim.cmd.colorscheme("zenbones")

require("quicker").setup({})

require("mini.completion").setup({})
require("mini.jump").setup({})
require("mini.jump2d").setup({})
require("mini.ai").setup({})
require("mini.surround").setup({})
require("mini.operators").setup({})
require("mini.icons").setup({})

require("hyblm.options")
require("hyblm.keymaps")
require("hyblm.task_runner")
require("hyblm.neovide")
require("hyblm.lsp")
require("hyblm.dap")
require("hyblm.ai")
