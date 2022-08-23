local awful     = require "awful"
local gears     = require "gears"
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

  local tasklist_buttons = {
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
		}

  local tasklist = awful.widget.tasklist {
    screen   = s,
    filter   = awful.widget.tasklist.filter.currenttags,
    buttons  = tasklist_buttons,
    style    = {
      shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, false, true, true, false, 15)
      end,
    },
    layout   = {
      spacing = 2,
      layout  = wibox.layout.fixed.vertical
    },
    widget_template = {
      {
        {
          wibox.widget.base.make_widget(),
          forced_width = 2,
          id = "background_role",
          shape = gears.shape.circle,
          widget = wibox.container.background
        },
        {
          awful.widget.clienticon,
          left = 4,
          right = 2,
          top = -8,
          bottom = -8,
          widget  = wibox.container.margin
        },
        nil,
        layout = wibox.layout.align.horizontal,
      },
      top = 15,
      bottom = 15,
      widget = wibox.container.margin
    },
  }

  client.connect_signal("manage", function(c)
  local apply_icon = function (icon)
      local cairo = require("lgi").cairo
      local s = gears.surface(icon)
      local img = cairo.ImageSurface.create(cairo.Format.ARGB32, s:get_width(), s:get_height())
      local cr = cairo.Context(img)
        cr:set_source_surface(s, 0, 0)
        cr:paint()
        c.icon = img._native
  end
    local icon = "/home/matt/.local/share/icons/WhiteSur-purple-dark-folders/categories/32/applications-other.svg"
    if c.class == "obsidian" then
      icon = "/usr/share/icons/Papirus-Dark/64x64/apps/obsidian.svg"
    elseif c.name == "Spotify" then
      icon = "/usr/share/icons/Papirus-Dark/64x64/apps/spotify.svg"
    end
    if c and c.valid and not c.icon then
      apply_icon(icon)
    end
    if c.name == "nvim" then
      icon = "/usr/share/icons/Papirus-Dark/64x64/apps/nvim.svg"
      apply_icon(icon)
    end
end)

  require "ui.widgets.controls"
  local control = wibox.widget{
    markup = "",
    font = "Material Icons Round 17",
    valign = "center",
    align = "center",
    widget = wibox.widget.textbox
  }
  control:buttons{gears.table.join(
    awful.button({}, 1, function()
      cc_toggle(s)
    end)
  )}

  local time = wibox.widget {
    {
      widget = wibox.widget.textclock,
      format = "%I\n%M",
      valign = "center",
      align = "center",
    },
    layout = wibox.layout.fixed.vertical,
    spacing = dpi (5),
  }
  local date = wibox.widget {
    {
      widget = wibox.widget.textclock,
      format = "%b\n%e",
      valign = "center",
      align = "center",
    },
    layout = wibox.layout.fixed.vertical,
    spacing = dpi (5),
  }


  local tray = wibox.widget {
    {
      {
        {
          {
            widget = wibox.widget.systray,
            horizontal = false,
          },
          margins = 4,
          widget = wibox.container.margin
        },
        bg = beautiful.bg_systray,
        shape = function(cr,width,height) gears.shape.rounded_bar(cr, width, height) end,
        widget = wibox.container.background
      },
      margins = 1,
      widget = wibox.container.margin
    },
    screen = "primary",
    widget = awful.widget.only_on_screen
  }

	-- Create the wibox
  local mybar = awful.wibar {
		position  = "left",
		bg        = xrdb.background .. '99',
    width     = dpi(32),
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
          margins = 2,
          widget = wibox.container.margin,
        },
        layout = wibox.layout.fixed.vertical,
        spacing = dpi (4),
      },
      { -- middle widgets
        tasklist,
        right = 0,
        widget = wibox.container.margin,
      },
      { -- bottom widgets
        tray,
        control,
        require "ui.widgets.battery",
        time,
        date,
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
