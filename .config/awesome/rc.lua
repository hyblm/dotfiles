--  ___ __    _____ ___ ___  __ _  ___
-- / _ `/ |/|/ / -_|_-</ _ \/  ' \/ -_)
-- \_,_/|__,__/\__/___/\___/_/_/_/\__/

pcall (require, "luarocks.loader")

local naughty = require "naughty"

-- {{{ Error handling
naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification {
		urgency = "critical",
		title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
		message = message
	}
end)
-- }}}

-- {{{ Variable definitions
-- This is used later as the default terminal and editor to run.
terminal = "wezterm"
browser = "firefox-developer-edition"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = "wezterm start " .. editor
-- editor_cmd = terminal .. " -e " .. editor
-- }}}

require "config"
require "ui"
