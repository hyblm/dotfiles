local wezterm = require("wezterm")

return {
	color_scheme = "tokyonight",
	font_size = 12,
	font = wezterm.font( "Fira Code" ),
	harfbuzz_features = { "zero", "cv14", "cv31", "ss03", "ss02" },
	enable_tab_bar = false,
	window_background_opacity = 0.95,
	window_padding = {
		top = 0,
		bottom = 0,
	},
}
