local gears = require("gears")

local corner_radius = 10

local round_corners = function(cr, w, h)
	gears.shape.rounded_rect(cr, w, h, corner_radius)
end

local function toggle_round_corners(client)
	-- local have_round_corners = true
  local have_round_corners = not client.maximized and not client.fullscreen
  if have_round_corners then
    client.shape = round_corners
    else
    client.shape = gears.shape.rect
  end
end

client.connect_signal("manage", toggle_round_corners)
client.connect_signal("property::maximized", toggle_round_corners)
client.connect_signal("property::fullscreen", toggle_round_corners)
