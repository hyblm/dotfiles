--    ___ __    _____ ___ ___  __ _  ___
--  / _ `/ |/|/ / -_|_-</ _ \/  ' \/ -_)
-- \_,_/|__,__/\__/___/\___/_/_/_/\__/

-- awesome_mode: api-level=4:screen=on
pcall(require, "luarocks.loader")

local gfs = require "gears.filesystem"
local naughty = require "naughty"
local awful = require "awful"
require "awful.autofocus"

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification {
		urgency = "critical",
		title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
		message = message
	}
end)
-- }}}

awful.spawn(gfs.get_xdg_config_home() .. "/wm_autostart")

-- {{{ Variable definitions
-- This is used later as the default terminal and editor to run.
terminal = "wezterm"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = "wezterm start " .. editor
-- editor_cmd = terminal .. " -e " .. editor
-- }}}

require "ui"
require "bindings"
require "rules"
require "notifications"
