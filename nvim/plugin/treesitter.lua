vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects'
})

local langs = { 'rust', 'lua', 'javascript', 'typescript', 'c', 'zig', 'asm' }
require('nvim-treesitter').install(langs)

for _, lang in ipairs(langs) do
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { lang },
    callback = function(ev)
      vim.treesitter.start(ev.buf, lang)
    end,
  })
end

vim.g.no_plugin_maps = true
require('nvim-treesitter-textobjects').setup({
})
