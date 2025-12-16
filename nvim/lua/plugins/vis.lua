return {
  { "rockerBOO/boo-colorscheme-nvim" },
  { "zenbones-theme/zenbones.nvim", dependencies = "rktjmp/lush.nvim", lazy = false, priority = 1000 },
  { "savq/melange-nvim", name = "malange" },
  { "webhooked/kanso.nvim", name = "kanso" },
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
