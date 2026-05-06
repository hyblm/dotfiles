---
name: nvim-docs
description: Use Neovim documentation for questions or tasks involving Neovim, nvim configuration, Lua APIs, Vimscript, options, keymaps, autocmds, LSP, plugins, or troubleshooting editor behavior.
---

# Neovim Documentation

When working on Neovim-related tasks, consult the local Neovim documentation in `/usr/share/nvim/runtime/doc` before answering or changing configuration.

## How to query docs

```bash
rg -n "<query>" /usr/share/nvim/runtime/doc
```

Useful doc files/topics include:

- `lua.txt` and `lua-guide.txt` for Lua configuration
- `api.txt` for Neovim Lua API
- `options.txt` for editor options
- `map.txt` for key mappings
- `autocmd.txt` for autocommands
- `lsp.txt` for built-in LSP
- `diagnostic.txt` for diagnostics
- `treesitter.txt` for Tree-sitter
- `starting.txt` for `runtimepath` and `packpath`

## Workflow

1. Identify likely search terms or help tags.
2. Run `rg` in `/usr/share/nvim/runtime/doc`.
3. Read the relevant doc file sections if needed.
4. Prefer documented APIs and current Neovim behavior over assumptions.
5. When editing config, keep changes idiomatic for Neovim Lua.
6. Mention the help tag or doc file used when useful, e.g. `:help vim.keymap.set()`.
