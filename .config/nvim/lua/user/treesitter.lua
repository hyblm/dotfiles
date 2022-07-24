require'nvim-treesitter.configs'.setup {
  -- ensure_installed = "maintained", -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- Install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "javascript" }, -- List of parsers to ignore installing

  highlight = {
    enable = true, -- `false` will disable the whole extension
    additional_vim_regex_highlighting = false,
  },
  indent = {
	enable = true,
  }
}

