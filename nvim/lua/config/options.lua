-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = false
vim.opt.number = false

if vim.g.neovide == true then
  vim.o.guifont = "Lilex Nerd Font:h11.4" -- the biggest that fits 2 full width views side by side
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_remember_window_position = true
  vim.api.nvim_set_keymap("n", "<F11>", ":let g:neovide_fullscreen = !g:neovide_fullscreen<CR>", {})
end
