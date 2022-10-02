local opts = { noremap = true, silent = true}
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
vim.keymap.set('n', 'gdj', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', 'gdk', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', 'gdl', require 'telescope.builtin'.diagnostics, opts)
-- vim.keymap.set('n', ' q', vim.diagnostic.setloclist, opts)

local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end
		vim.keymap.set('n', keys, func, {
			noremap = true, silent = true, buffer = bufnr, desc = desc
		})
	end

	nmap('gd', vim.lsp.buf.definition, '[g]oto [d]efinition')
	nmap('gD', vim.lsp.buf.declaration, '[g]oto [D]eclatarion')
	nmap('gT', vim.lsp.buf.declaration, '[g]oto [T]ype definition')
	nmap('gi', vim.lsp.buf.implementation, '[g]oto [i]implementation')
	nmap('ca', vim.lsp.buf.code_action, '[C]ode [A]action')
	nmap( 'K', vim.lsp.buf.hover, 'Show Documentation')
	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
	nmap('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
	nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>ws', require('telescope.builtin').lsp_workspace_symbols, '[W]orkspace [S]ymbols')
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local signs = {
	{ name = "DiagnosticSignError", text = "" },
	{ name = "DiagnosticSignWarn", text = "" },
	{ name = "DiagnosticSignHint", text = "" },
	{ name = "DiagnosticSignInfo", text = "" },
}
for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.diagnostic.config({
	virtual_text = false,
	signs = { active = signs },
})

local servers = { 'sumneko_lua', 'rust_analyzer', 'pyright', 'clangd', 'tsserver' }

require('nvim-lsp-installer').setup { ensure_installed = servers }

for _, ls in ipairs(servers) do
	require('lspconfig')[ls].setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require 'lspconfig'.sumneko_lua.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = { version = 'LuaJIT', path = runtime_path },
			diagnostics = { globals = { 'vim' } },
			workspace = { library = vim.api.nvim_get_runtime_file('', true) },
		}
	}
}
