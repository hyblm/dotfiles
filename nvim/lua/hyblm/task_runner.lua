local last_task = nil

local function run_task(cmd)
        vim.cmd("write")
        vim.cmd("!" .. cmd)
end

vim.keymap.set("n", "<M-C-T>", function()
        local cmd = vim.fn.input("Task: ")

        if cmd == "" then
                return
        end

        last_task = cmd
        run_task(cmd)
end, { desc = "Run task" })

vim.keymap.set("n", "<M-t>", function()
        if not last_task then
                vim.notify("No task has been run yet", vim.log.levels.WARN)
                return
        end

        run_task(last_task)
end, { desc = "Rerun last task" })
