return {
  { "savq/melange-nvim", name = "malange" },
  {
    "wtfox/jellybeans.nvim",
    lazy = false,
    priority = 1000,
    opts = {}, -- Optional
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "jellybeans",
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
}
