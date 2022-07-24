local beautiful = require "beautiful"
local gears     = require "gears"
local gfs       = require "gears.filesystem"

-- Source wallpaper once, if a theme sets a wallpaper it will overwrite this option
beautiful.wallpaper = os.getenv("XDG_CONFIG_HOME") .. "/wall.png"

-- Set the theme
local theme = "hyma"
beautiful.init(gfs.get_configuration_dir() .. "themes/" .. theme .. "/theme.lua")

-- {{{ Wallpaper
screen.connect_signal("request::wallpaper", function(s)
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, false)
	end
end)
-- }}}

require "ui.bar"
require "ui.titlebars"
require "ui.menu"
require "ui.round_corners"
