-- battery widget
--------------------
local wibox         = require "wibox"
local gears         = require "gears"
local beautiful     = require "beautiful"
local xrdb          = beautiful.xresources.get_current_theme()
local dpi           = beautiful.xresources.apply_dpi
local upower_widget = require 'modules.battery'

local charging_icon = wibox.widget {
  markup = "<span foreground='" .. "#fff" .. "'></span>",
  font = " Material Icons Round 13",
  align = "center",
  valign = "center",
  visible = false,
  widget = wibox.widget.textbox
}

local battery_bar = wibox.widget {
  max_value 			 = 100,
  value            = 70,
  forced_width     = dpi(28),
  border_width     = dpi(2),
  color				     = beautiful.fg_normal,
  background_color = "#0000",
  border_color     = beautiful.fg_darker,
  paddings         = dpi(1),
  bar_shape        = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 2) end,
  shape				     = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 4) end,
  widget           = wibox.widget.progressbar,
}

local battery_bud = wibox.widget {
  widget = wibox.container.background,
  forced_height = 6,
  bg = beautiful.fg_darker,
  shape = function(cr, width, height)
    gears.shape.pie(cr, width, height, math.pi, 0)
  end
}

local battery = wibox.widget {
  {
    {
      {
        battery_bud,
        margins = 0,
        widget = wibox.container.margin
      },
      {
        battery_bar,
        direction = "east",
        widget = wibox.container.rotate
      },
      spacing = dpi(-2),
      layout = wibox.layout.fixed.vertical
    },
    {
      charging_icon,
      margins = {top = dpi(4)},
      widget = wibox.container.margin,
    },
    layout = wibox.layout.stack,
  },
  widget = wibox.container.margin,
  margins = {left = dpi(8),right = dpi(8)}
}

local battery_listener = upower_widget {
  device_path = '/org/freedesktop/UPower/devices/battery_BAT0',
  instant_update = true
}

battery_listener:connect_signal("upower::update", function(_, device)
  awesome.emit_signal("signal::battery", math.floor(device.percentage), device.state)
end)

awesome.connect_signal("signal::battery", function(value, state)
  battery_bar.value = value


  if state == 1 then
    -- charging_icon.visible = true
    battery_bar.color = xrdb.color2
  else
    -- charging_icon.visible = true
    if value < 16 then
      battery_bar.color = xrdb.color1
    else
      battery_bar.color = beautiful.fg_normal
    end
  end

end)

return battery
