vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })

local langs = { 'rust', 'lua', 'javascript', 'typescript', 'c', 'zig', 'asm' }
require('nvim-treesitter').install(langs)

for _, lang in ipairs(langs) do
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { lang },
    callback = function()
      -- vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      -- vim.wo[0][0].foldmethod = 'expr'
      vim.treesitter.start()
    end,
  })
end
