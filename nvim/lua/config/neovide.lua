if vim.g.neovide == true then
  vim.o.guifont = "Lilex Nerd Font:h11.4" -- the biggest that fits 2 full width views side by side
  vim.api.nvim_set_keymap("n", "<F11>", ":let g:neovide_fullscreen = !g:neovide_fullscreen<CR>", {})
end
