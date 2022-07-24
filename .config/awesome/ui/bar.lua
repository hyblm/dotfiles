local awful = require "awful"
local wibox = require "wibox"
local gears = require "gears"
local beautiful = require "beautiful"
local gfs   = require "gears.filesystem"
local xrdb = beautiful.xresources.get_current_theme()

require "widgets.tod"

tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.tile,
		awful.layout.suit.max,
		awful.layout.suit.floating,
	})
end)

screen.connect_signal("request::desktop_decoration", function(s)
	s.mypromptbox = awful.widget.prompt()
	s.mylayoutbox = awful.widget.layoutbox {
		screen  = s,
		buttons = {
			awful.button({ }, 1, function () awful.layout.inc( 1) end),
			awful.button({ }, 3, function () awful.layout.inc(-1) end),
			awful.button({ }, 4, function () awful.layout.inc(-1) end),
			awful.button({ }, 5, function () awful.layout.inc( 1) end),
		}
	}

	awful.tag({ "󰵅", "󰆋", "󰘸", "󰘳", "󰭛", "󰟡", "󰙀"}, s, awful.layout.layouts[1])
	s.mytaglist = awful.widget.taglist {
		screen  = s,
		filter  = awful.widget.taglist.filter.noempty,
		style = { spacing = 5, font = "Material Design Icons Desktop 14"},
		buttons = {
			awful.button({ }, 1, function(t) t:view_only() end),
			awful.button({ modkey }, 1, function(t)
				if client.focus then
					client.focus:move_to_tag(t)
				end
			end),
			awful.button({ }, 3, awful.tag.viewtoggle),
			awful.button({ modkey }, 3, function(t)
				if client.focus then
					client.focus:toggle_tag(t)
				end
			end),
			awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
			awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
		}
	}

	s.mytasklist = awful.widget.tasklist {
		screen  = s,
		filter  = awful.widget.tasklist.filter.currenttags,
		buttons = {
			awful.button({ }, 1, function (c)
				c:activate { context = "tasklist", action = "toggle_minimization" }
			end),
			awful.button({ }, 2, function(c) c:kill() end),
			awful.button({ }, 3, function(c)
				local actions = {
					{ "Float", function() c.floating = not c.floating c:raise() end},
					{ "Maximize", function() c.maximized = not c.maximized c:raise() end},
					{ "Fullscreen", function() c.fullscreen = not c.fullscreen c:raise() end},
					{ "Sticky", function() c.sticky = not c.sticky c:raise() end},
				}
				awful.menu(actions):show()
			end),
			awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
			awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
		},
		layout = {
			spacing = 20,
			layout = wibox.layout.flex.horizontal,
		},
		style = {
			shape = function(cr, w, h) gears.shape.partially_rounded_rect(cr, w, h, false, false, true, true, 12) end,
		},
		widget_template = {
			{nil,
				{{
					awful.widget.clienticon,
					top = 1 ,
					bottom = 2,
					right = 8,
					widget = wibox.container.margin,
					},
					{
						id = "text_role",
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.align.horizontal,
				},
				expand = "outside",
				layout = wibox.layout.align.horizontal,
			},
			id = "background_role",
			widget = wibox.container.background,
		},
	}

	-- Create the wibox
	s.mywibox = awful.wibar {
		position = "top",
		screen   = s,
		bg = xrdb.background .. '99',
		widget   = {
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				wibox.container.margin(s.mylayoutbox, 5,10,5,5),
				s.mytaglist,
				wibox.container.margin(awful.widget.keyboardlayout, 5, 5),
        require 'widgets.tod',
				s.mypromptbox,
			},
			wibox.container.margin(s.mytasklist, 20, 20),
			{ -- Right widgets
				layout = wibox.layout.fixed.horizontal,
				wibox.container.margin(wibox.widget.systray, 0, 0),
				wibox.container.margin(require "widgets.battery" {path_to_icons = gfs.get_xdg_data_home() .. "/icons/WhiteSur-purple-dark/status/24/"}, 18, 10),
				wibox.container.margin(wibox.widget.textclock("%a  %b %e  %l:%M %p"), 10, 15),
			},
		}
	}
end)
