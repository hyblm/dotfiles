require 'telescope'.setup {
	defaults = {
		prompt_prefix = ":: "
	},
	extensions = {
		file_browser = {
			theme = "ivy",
			hijack_netrw = true,
		}
	}
}
require('telescope').load_extension 'fzf'
require('telescope').load_extension 'file_browser'
require('telescope').load_extension 'ui-select'
