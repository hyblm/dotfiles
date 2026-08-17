if vim.g.neovide == true then
  vim.o.guifont = "Lilex Nerd Font:h11.4" -- Fits two full-width views side by side.
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_remember_window_position = true
  vim.keymap.set("n", "<F11>", function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end, { desc = "Toggle fullscreen" })
end
