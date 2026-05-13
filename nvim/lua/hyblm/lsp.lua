vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })

vim.lsp.enable('rust_analyzer')
vim.lsp.enable('clangd')
vim.lsp.enable('astro')
vim.lsp.enable('oxlint')
vim.lsp.enable('oxfmt')
vim.lsp.enable('ts_ls')
vim.lsp.enable('markdown_oxide')
vim.lsp.config('lua_ls', { settings = { Lua = { workspace = { library = { vim.env.VIMRUNTIME } } } } })
vim.lsp.enable('lua_ls')
vim.lsp.enable('stylua')

vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

vim.diagnostic.config({ virtual_lines = true })
vim.keymap.set('n', 'gK', function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    -- vim.keymap.set("n", "<S-K>", vim.lsp.buf.hover)

    if client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end,
      })
    end
  end
})
