-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local overseer_restart_last_task = function()
  local overseer = require("overseer")
  local tasks = overseer.list_tasks({ recent_first = true })
  if vim.tbl_isempty(tasks) then
    vim.notify("No tasks found", vim.log.levels.WARN)
  else
    overseer.run_action(tasks[1], "restart")
  end
end

vim.api.nvim_create_user_command("OverseerRestartLast", overseer_restart_last_task, {})
vim.keymap.set({ "n", "i", "v" }, "<M-t>", overseer_restart_last_task)
