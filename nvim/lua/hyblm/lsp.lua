vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

vim.lsp.config("rust_analyzer", {
  cmd = { "rustup", "run", "stable", "rust-analyzer" },
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = true,
      check = {
        workspace = false,
        command = "clippy",
        extraArgs = {
          "--",
          "-D",
          "clippy::correctness",
          "-D",
          "clippy::suspicious",
          "-D",
          "clippy::style",
          "-D",
          "clippy::complexity",
          "-D",
          "clippy::perf",
          "-W",
          "clippy::absolute_paths",
          "-W",
          "clippy::excessive_nesting",
          -- "-W", "clippy::too_many_lines",
          "-W",
          "clippy::dbg_macro",
          "-W",
          "clippy::deref_by_slicing",
          "-W",
          "clippy::else_if_without_else",
          "-W",
          "clippy::get_unwrap",
          "-W",
          "clippy::if_then_some_else_none",
          "-W",
          "clippy::impl_trait_in_params",
          "-W",
          "clippy::missing_asserts_for_indexing",
          -- "-W", "clippy::missing_inline_in_public_items",
          "-W",
          "clippy::mod_module_files",
          "-W",
          "clippy::module_name_repetitions",
          "-W",
          "clippy::multiple_unsafe_ops_per_block",
          "-W",
          "clippy::mutex_atomic",
          "-W",
          "clippy::rc_buffer",
        },
      },
    },
  },
})
vim.lsp.enable("rust_analyzer")

vim.lsp.config("stylua", {
  cmd = {
    "stylua",
    "--lsp",
    "--indent-type",
    "Spaces",
    "--indent-width",
    "2",
    "--collapse-simple-statement",
    "Never",
    "--column-width",
    "120",
    "--quote-style",
    "AutoPreferDouble",
    "--call-parentheses",
    "Input",
  },
})
vim.lsp.enable("stylua")
vim.lsp.config("lua_ls", { settings = { Lua = { workspace = { library = { vim.env.VIMRUNTIME } } } } })
vim.lsp.enable("lua_ls")

vim.lsp.enable("clangd")
vim.lsp.enable("astro")
vim.lsp.enable("oxlint")
vim.lsp.enable("oxfmt")
vim.lsp.enable("ts_ls")
vim.lsp.enable("markdown_oxide")

vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

--- @param diagnostic? vim.Diagnostic
--- @param bufnr integer
local function on_jump(diagnostic, bufnr)
  if not diagnostic then
    return
  end

  vim.diagnostic.show(
    diagnostic.namespace,
    bufnr,
    { diagnostic },
    { virtual_lines = { current_line = true }, virtual_text = false }
  )
end
vim.diagnostic.config({ jump = { on_jump = on_jump } })

vim.diagnostic.config({ virtual_text = true })
vim.keymap.set("n", "<leader>td", function()
  local new_config = not vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = new_config })
end, { desc = "Toggle diagnostic virtual_lines" })

local format_group = vim.api.nvim_create_augroup("hyblm.format", { clear = true })
local project_formatters = {}

local function find_package_json(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then
    return
  end

  return vim.fs.find("package.json", {
    path = vim.fs.dirname(path),
    upward = true,
    type = "file",
  })[1]
end

local function package_manager(root)
  if vim.uv.fs_stat(root .. "/pnpm-lock.yaml") then
    return "pnpm"
  end
  if vim.uv.fs_stat(root .. "/yarn.lock") then
    return "yarn"
  end
  if vim.uv.fs_stat(root .. "/bun.lockb") or vim.uv.fs_stat(root .. "/bun.lock") then
    return "bun"
  end
  return "npm"
end

local function project_format_command(bufnr)
  local package_json = find_package_json(bufnr)
  if not package_json then
    return
  end

  local ok, package = pcall(vim.json.decode, table.concat(vim.fn.readfile(package_json), "\n"))
  if not ok or not package.scripts or not package.scripts.format then
    return
  end

  local root = vim.fs.dirname(package_json)
  local manager = package_manager(root)
  return root, manager
end

local function use_project_formatter(bufnr)
  local root, manager = project_format_command(bufnr)
  if not root or not manager then
    return false
  end

  if project_formatters[root] then
    return true
  end
  project_formatters[root] = true

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = format_group,
    pattern = "*",
    callback = function(args)
      local path = vim.api.nvim_buf_get_name(args.buf)
      if not vim.startswith(path, root .. "/") then
        return
      end
      if vim.b[args.buf].project_format_running then
        return
      end
      vim.b[args.buf].project_format_running = true

      local relative_path = vim.fs.relpath(root, path) or path
      local cmd = manager == "npm" and { manager, "run", "format", "--", relative_path }
          or { manager, "format", "--", relative_path }

      vim.system(cmd, { cwd = root, text = true }, function(result)
        vim.schedule(function()
          vim.b[args.buf].project_format_running = false
          if result.code == 0 then
            vim.cmd.checktime()
          else
            vim.notify(result.stderr ~= "" and result.stderr or result.stdout, vim.log.levels.ERROR)
          end
        end)
      end)
    end,
  })

  return true
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    -- vim.keymap.set("n", "<S-K>", vim.lsp.buf.hover)

    if client:supports_method("textDocument/definition") then
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf, desc = "Go to definition" })
    end

    if client:supports_method("textDocument/declaration") then
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = args.buf, desc = "Go to declaration" })
    end

    if client:supports_method("textDocument/typeDefinition") then
      vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { buffer = args.buf, desc = "Go to type definition" })
    end

    if client:supports_method("textDocument/formatting") and not use_project_formatter(args.buf) then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        buffer = args.buf,
        callback = function()
          local format_opts = { bufnr = args.buf, id = client.id }

          if client.name == "astro" then
            format_opts.formatting_options = {
              insertSpaces = true,
              tabSize = 2,
            }
          end

          vim.lsp.buf.format(format_opts)
        end,
      })
    end
  end,
})
