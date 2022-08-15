local wibox = require 'wibox'
local gears = require 'gears'
-- local awful = require 'awful'
local beautiful = require 'beautiful'

local task_text = wibox.widget.textbox("Show next task")

local button = wibox.widget {
  {
    {
      {
        image = "/home/matt/.local/share/icons/todoist_white.png",
        resize = true,
        forced_width = 20,
        forced_height = 20,
        widget = wibox.widget.imagebox,
      },
      margins = 6,
      widget = wibox.container.margin,
    },
    {
      task_text,
      right = 15,
      widget = wibox.container.margin
    },
    layout = wibox.layout.fixed.horizontal
  },
  bg = beautiful.bg_normal .. "00",
  shape = function (cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
  widget = wibox.container.background
}

local old_cursor, old_wibox
button:connect_signal("mouse::enter", function(c)
  c:set_bg(beautiful.bg_normal .. "99")
  local wb = mouse.current_wibox
  old_cursor, old_wibox = wb.cursor, wb
  wb.cursor = "hand1"
end)
button:connect_signal("mouse::leave", function(c)
  c:set_bg(beautiful.bg_normal .. "00")
  if old_wibox then
    old_wibox.cursor = old_cursor
    old_wibox = nil
  end
end)

button:connect_signal("button::press", function(c)
  c:set_bg(beautiful.bg_clicked .. "cc")
  local handle = io.popen("tod -np inbox | sed '/^$/d'", "r")
  local task = handle:read("*l")
  handle:close()
  task_text:set_text(task)
end)

return button
