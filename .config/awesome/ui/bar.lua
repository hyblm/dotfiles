local awful     = require "awful"
local wibox     = require "wibox"
local beautiful = require "beautiful"
local xrdb      = beautiful.xresources.get_current_theme()
local dpi       = beautiful.xresources.apply_dpi

tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.tile,
		awful.layout.suit.max,
		awful.layout.suit.floating,
	})
end)

screen.connect_signal("request::desktop_decoration", function(s)
	local layoutbox = awful.widget.layoutbox {
		screen  = s,
		buttons = {
			awful.button({ }, 1, function () awful.layout.inc( 1) end),
			awful.button({ }, 3, function () awful.layout.inc(-1) end),
			awful.button({ }, 4, function () awful.layout.inc(-1) end),
			awful.button({ }, 5, function () awful.layout.inc( 1) end),
		}
	}

	awful.tag({ "󰵅", "󰆋", "󰘸", "󰘳", "󰭛", "󰟡", "󰙀"}, s, awful.layout.layouts[1])
	local taglist = awful.widget.taglist {
		screen  = s,
		filter  = awful.widget.taglist.filter.noempty,
		style = { spacing = 12, font = "Material Design Icons Desktop 15"},
    layout = wibox.layout.fixed.vertical,
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

	local tasklist = awful.widget.tasklist {
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
			layout = wibox.layout.flex.vertical,
		},
		widget_template = {
			{nil,
				{{
					awful.widget.clienticon,
					margins = 2,
					widget = wibox.container.margin,
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

  local clock = wibox.widget {
    {
      widget = wibox.widget.textclock,
      format = "%I\n%M",
      valign = "center",
      align = "center",
    },
    --[[ {
      widget = wibox.widget.textclock,
      format = "%b %e",
      valign = "center",
      align = "center",
    }, ]]
    layout = wibox.layout.fixed.vertical,
    spacing = dpi (5),
  }

	-- Create the wibox
  local mybar = awful.wibar {
		position  = "left",
		bg        = xrdb.background .. '99',
    width     = dpi(35),
    type      = "dock",
    screen    = s,
	}

  mybar:setup {
    {
      { -- top widgets
        {
          layoutbox,
          margins = 8,
          widget = wibox.container.margin,
        },
        {
          taglist,
          margins = 3,
          widget = wibox.container.margin,
        },
        layout = wibox.layout.fixed.vertical,
        spacing = dpi (4),
      },
      { -- middle widgets
        tasklist,
        margins = 3,
        widget = wibox.container.margin,
      },
      { -- bottom widgets
        require "widgets.battery",
        clock,
        layout = wibox.layout.fixed.vertical,
        spacing = dpi (15),
      },
      layout = wibox.layout.align.vertical,
      expand = "none",
    },
    layout = wibox.container.margin,
    top = 5,
    bottom = 15,
  }
end)
