local task = nil

local function run_task(cmd)
  vim.cmd({ cmd = "make", args = { task } })
end

vim.keymap.set("n", "<M-C-T>", function()
  local cmd = vim.fn.input("Task: ")

  if cmd == "" then
    return
  end

  task = cmd
  run_task(cmd)
end, { desc = "Run task" })

vim.keymap.set("n", "<M-t>", function()
  if not task then
    local cmd = vim.fn.input("Task: ")

    if cmd == "" then
      return
    end

    task = cmd
  end

  run_task(task)
end, { desc = "Rerun last task" })
