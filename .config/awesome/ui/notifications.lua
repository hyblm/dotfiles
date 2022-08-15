local awful     = require "awful"
local wibox     = require "wibox"
local ruled     = require "ruled"
local naughty   = require "naughty"
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = { },
        properties = { screen = awful.screen.preferred, implicit_timeout = 5}
    }
end)

naughty.connect_signal("request::display", function(n)
  local action_widget = {
    {
      {
        id = "text_role",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
      },
      margins = dpi(5),
      widget = wibox.container.margin
    },
    forced_height = dpi(30),
    widget = wibox.container.background
  }

  local actions = wibox.widget {
    notification = n,
    base_layout = wibox.widget {
      spacing = dpi(8),
      layout = wibox.layout.flex.horizontal
    },
    widget_template = action_widget,
    style = {underline_normal = false, underline_selected = true},
    widget = naughty.list.actions
  }

end)
