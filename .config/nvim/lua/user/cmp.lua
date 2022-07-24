vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

local cmp = require 'cmp'
local lspkind = require 'lspkind'

cmp.setup {
	mapping = cmp.mapping.preset.insert {
		['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
		['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<C-y>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
			},
		['<C-e>'] = cmp.mapping {
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		},
	},
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	sources = cmp.config.sources {
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lua' },
		{ name = 'luasnip' },
		{ name = 'path' },
		{ name = 'buffer' },
		{ name = 'cmdline' },
	},
	formatting = {
		format = lspkind.cmp_format {
			with_text = true,
			menu = {
				nvim_lsp  =  '[LSP]',
				buffer    =  '[buf]',
				nvim_lua  =  '[lua_api]',
				path      =  '[path]',
				cmdline   =  '[cmdline]',
				luasnip   =  '[snip]',
			}}},
	experimental = {
		ghost_text = true,
	}
}

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = 'buffer' , keywork_length = 5 },
	})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})
