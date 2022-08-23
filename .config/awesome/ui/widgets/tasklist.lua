local awful = require "awful"
local wibox = require "wibox"

local tasklist = awful.widget.tasklist {
  -- screen  = s,
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

return tasklist
