vim.pack.add({ 'https://github.com/folke/todo-comments.nvim', })

local todo = require('todo-comments')
todo.setup {}
vim.keymap.set("n", "<leader>t", function() vim.cmd("TodoFzfLua") end, { desc = "Next todo comment" })
vim.keymap.set("n", "]t", todo.jump_next, { desc = "Next todo comment" })
vim.keymap.set("n", "[t", todo.jump_prev, { desc = "Previous todo comment" })
