local awful     = require "awful"
local wibox     = require "wibox"
local gears     = require "gears"
local beautiful = require "beautiful"
local dpi       = beautiful.xresources.apply_dpi

awful.screen.connect_for_each_screen(function(s)

  -- Mainbox
  control_c = wibox({
    type = "dock",
    shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 18) end,
    screen = s,
    width = dpi(420),
    margins = 20,
    ontop = true,
    visible = false
  })

  -- toggle
  local screen_backup = 1

  cc_toggle = function(screen)

    -- set screen to default if none were found
    if not screen then
      screen = s
    end

    -- control center position
    control_c.x = screen.geometry.x + dpi(50)

    -- toggle visibility
    if control_c.visible then
      if screen_backup ~= screen.index then
        control_c.visible = true
      else
        control_c.visible = false
      end
    else
      control_c.visible = true
    end

    screen_backup = screen.index

  end

  control_c:setup {
    {
      wibox.widget.textclock(),
      margins = 10,
      widget = wibox.container.margin
    },
    layout = wibox.layout.fixed.vertical
  }
end)
