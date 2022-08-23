---------------------------------------------
-- Awesome theme which follows xrdb config --
--   by Yauhen Kirylau                    --
---------------------------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gdebug = require("gears.debug")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local images = gfs.get_xdg_data_home() .. "/themes/Graphite-purple-dark-compact-hdpi/xfwm4/"

-- inherit default theme
local theme = dofile(themes_path.."default/theme.lua")
-- load vector assets' generators for this theme

theme.fontf         = "SF Pro Display"
theme.font          = theme.fontf .. " Semibold 11"

theme.bg_normal     = xrdb.background --.. "00"
theme.bg_focus      = xrdb.background --.. "aa"
theme.bg_clicked    = xrdb.color3
theme.bg_urgent     = xrdb.color9
theme.bg_minimize   = xrdb.color0 .. "cc"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = '#ddd'
theme.fg_focus      = '#fff'
theme.fg_urgent     = theme.bg_normal
theme.fg_minimize   = xrdb.color15

theme.useless_gap   = dpi(2)
theme.border_width  = dpi(1)
theme.border_color_normal = theme.bg_normal
theme.border_color_active = xrdb.color0 .. "55"
theme.border_color_marked = xrdb.color10

theme.taglist_bg_focus = "#0000"
-- theme.taglist_fg_focus = '#fc0'
theme.taglist_fg_occupied = xrdb.color7
theme.tasklist_bg_focus = "#0000"
theme.tasklist_bg_normal = "#0000"
theme.tasklist_fg_normal = xrdb.color7

theme.tooltip_fg = theme.fg_normal
theme.tooltip_bg = theme.bg_normal

theme.systray_icon_spacing = 15

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(25)
-- theme.menu_width  = dpi(500)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Recolor Layout icons:
theme = theme_assets.recolor_layout(theme, theme.fg_normal)

-- Recolor titlebar icons:
local function darker(color_value, darker_n)
    local result = "#"
    for s in color_value:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
        local bg_numeric_value = tonumber("0x"..s) - darker_n
        if bg_numeric_value < 0 then bg_numeric_value = 0 end
        if bg_numeric_value > 255 then bg_numeric_value = 255 end
        result = result .. string.format("%2.2x", bg_numeric_value)
    end
    return result
end
theme = theme_assets.recolor_titlebar(
    theme, theme.fg_normal, "normal"
)
theme = theme_assets.recolor_titlebar(
    theme, darker(theme.fg_normal, -60), "normal", "hover"
)
theme = theme_assets.recolor_titlebar(
    theme, xrdb.color1, "normal", "press"
)
theme = theme_assets.recolor_titlebar(
    theme, theme.fg_focus, "focus"
)
theme = theme_assets.recolor_titlebar(
    theme, darker(theme.fg_focus, -60), "focus", "hover"
)
theme = theme_assets.recolor_titlebar(
    theme, xrdb.color1, "focus", "press"
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
-- theme.icon_theme = "Papirus-Dark"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Generate taglist squares:
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Try to determine if we are running light or dark colorscheme:
local bg_numberic_value = 0;
for s in theme.bg_normal:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
    bg_numberic_value = bg_numberic_value + tonumber("0x"..s);
end
local is_dark_bg = (bg_numberic_value < 383)

-- Set different colors for urgent notifications.
rnotification.connect_signal('request::rules', function()
    rnotification.append_rule {
        rule       = { urgency = 'critical' },
        properties = { bg = '#ff0000', fg = '#ffffff' }
    }
end)

theme.wallpaper = gfs.get_xdg_config_home() .. "/wall.png"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
