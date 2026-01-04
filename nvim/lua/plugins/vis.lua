return {
  { "savq/melange-nvim", name = "melange" },
  {
    "wtfox/jellybeans.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- italics = false,
      -- bold = false,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "jellybeans-mono",
    },
  },
  {
    "folke/todo-comments.nvim",
    opts = {
      highlight = {
        pattern = [[.*<((KEYWORDS)(\(\w+\))?)\s*:]],
      },
      search = {
        pattern = [[\b(KEYWORDS)(?:\(\w+\))?\s*:]],
      },
    },
  },
  {
    "stevearc/overseer.nvim",
    keys = {
      { "<leader>ow", "<cmd>OverseerToggle right<cr>", desc = "Task list" },
    },
  },
}
