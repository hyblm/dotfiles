local wezterm = require("wezterm")

return {
	color_scheme = "Builtin Pastel Dark",
	font_size = 13,
	-- font = wezterm.font_with_fallback { "Fira Code", "Material Icons"},
	font = wezterm.font "Fira Code",
	harfbuzz_features = { "zero", "cv14", "cv31", "ss03", "ss02" },
	enable_tab_bar = false,
	-- window_background_opacity = 0.95,
	window_padding = {
		top = 0,
		bottom = 0,
	},
}
