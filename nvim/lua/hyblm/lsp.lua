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

    if client:supports_method("textDocument/definition") then
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf, desc = "Go to definition" })
    end

    if client:supports_method("textDocument/declaration") then
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = args.buf, desc = "Go to declaration" })
    end

    if client:supports_method("textDocument/typeDefinition") then
      vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { buffer = args.buf, desc = "Go to type definition" })
    end

    if client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function()
          local format_opts = { bufnr = args.buf, id = client.id }

          if client.name == 'astro' then
            format_opts.formatting_options = {
              insertSpaces = true,
              tabSize = 2,
            }
          end

          vim.lsp.buf.format(format_opts)
        end,
      })
    end
  end
})
