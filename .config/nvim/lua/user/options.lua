local options = {

number         = true,
relativenumber = true,

termguicolors = true,
cursorline    = true,
laststatus    = 3,
signcolumn    = 'yes',
colorcolumn   = '100',
listchars     = {tab = '󰌒  ', trail = '󱁐', eol = '󰌑'},


mouse         = 'a',
scrolloff     = 10,
sidescrolloff = 10,
splitbelow    = true,
splitright    = true,

hidden      = true,
errorbells  = false,

tabstop     = 2,
softtabstop = 2,
shiftwidth  = 2,
expandtab   = true,

smartindent = true,
wrap        = false,

incsearch   = true,
hlsearch    = true,
ignorecase  = true,
smartcase   = true,

swapfile    = false,
backup      = false,
undofile    = true,

fileencoding = 'utf-8',
clipboard    = 'unnamedplus',
guifont      = 'Fira Code:h11',
}

for key, value in pairs(options) do
	vim.opt[key] = value
end

vim.opt.shortmess:append("c")

vim.cmd[[colorscheme boo]]
vim.cmd[[highlight Normal guibg=none]] -- use the background of the terminal emulator
