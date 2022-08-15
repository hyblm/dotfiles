-- battery widget
--------------------
local wibox         = require "wibox"
local gears         = require "gears"
local beautiful     = require "beautiful"
local xrdb          = beautiful.xresources.get_current_theme()
local dpi           = beautiful.xresources.apply_dpi
local upower_widget = require 'modules.battery'

local bat_icon = wibox.widget {
  markup = "<span foreground='" .. "#eee" .. "'></span>",
  font = " Material Icons Round 12",
  align = "center",
  valign = "center",
  widget = wibox.widget.textbox
}

local battery_progress = wibox.widget{
  color				     = xrdb.color6,
  background_color = "#0000",
  forced_width     = dpi(30),
  border_width     = dpi(1),
  border_color     = "#eee9",
  paddings         = dpi(1),
  bar_shape        = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 2) end,
  shape				     = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 4) end,
  value            = 70,
  max_value 			 = 100,
  widget           = wibox.widget.progressbar,
}

local battery_bud = wibox.widget {
  widget = wibox.container.background,
  bg = "#eee9",
  forced_width = dpi(9),
  forced_height = dpi(9),
  shape = function(cr, width, height)
    gears.shape.pie(cr,width, height, 0, math.pi)
  end
}

local battery = wibox.widget {
  {
    {
      {
        battery_bud,
        direction = "south",
        widget = wibox.container.rotate
      },
      {
        battery_progress,
        direction = "east",
        widget = wibox.container.rotate()
      },
      layout = wibox.layout.fixed.vertical,
      spacing = dpi(-4)
    },
    {
      bat_icon,
      margins = {top = dpi(8)},
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
  battery_progress.value = value

  if value < 15 then
    battery_progress.color = xrdb.color1
  end

  if state == 1 then
    bat_icon.visible = true
  else
    bat_icon.visible = false
  end

end)

return battery
