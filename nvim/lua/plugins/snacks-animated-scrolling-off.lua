return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
      animate = { enabled = false },
    },
  },
  { "akinsho/bufferline.nvim", enabled = false },
  { "neovim/nvim-lspconfig", opts = {
    inlay_hints = {
      enabled = false,
    },
  } },
}
