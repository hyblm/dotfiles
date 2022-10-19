--  ___ __    _____ ___ ___  __ _  ___
-- / _ `/ |/|/ / -_|_-</ _ \/  ' \/ -_)
-- \_,_/|__,__/\__/___/\___/_/_/_/\__/

pcall (require, "luarocks.loader")

require("awful.autofocus")

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
