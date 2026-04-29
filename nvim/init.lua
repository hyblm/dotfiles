vim.pack.add({
        'https://github.com/nvim-mini/mini.completion',      -- Autocompletion
        'https://github.com/stevearc/quicker.nvim',          -- Enhanced quickfix/loclist
        'https://github.com/lewis6991/gitsigns.nvim',        -- Git integration
        'https://github.com/wtfox/jellybeans.nvim',          -- colorscheme
        'https://github.com/nvim-mini/mini.ai',
        'https://github.com/nvim-mini/mini.surround',
        'https://github.com/nvim-mini/mini.operators',
        'https://github.com/nvim-mini/mini.icons',
        'https://github.com/nvim-mini/mini.snippets'
})

require('mini.completion').setup {}
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

vim.cmd.colorscheme("jellybeans")
