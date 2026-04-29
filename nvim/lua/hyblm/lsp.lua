vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })

vim.lsp.enable('rust_analyzer')
vim.lsp.enable('clangd')
vim.lsp.enable('astro')
vim.lsp.config('lua_ls', { settings = { Lua = { workspace = { library = { vim.env.VIMRUNTIME }}} }})
vim.lsp.enable('lua_ls')
vim.lsp.enable('stylua')

