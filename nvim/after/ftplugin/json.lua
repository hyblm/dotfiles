vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    if vim.fn.executable("jq") == 1 then
      vim.cmd("%!jq")
    end
  end,
})
