local awful         = require "awful"
local beautiful     = require "beautiful"
local hotkeys_popup = require "awful.hotkeys_popup"
local xrandr        = require "snippets.xrandr"
local handy         = require "modules.handy"

local modkey = "Mod4"
local shift  = "Shift"
local ctrl   = "Control"
local alt    = "Mod1"

function run_once (prog, arg_string, pname, screen)
    if not prog then
    do return nil end
    end
if not pname then
       pname = prog
    end

    if not arg_string then 
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
      else
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. " ".. arg_string .."' || (" .. prg .. " " .. arg_string .. ")",screen)
    end
end

-- {{{ Mouse bindings
awful.mouse.append_global_mousebindings {
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, function() beautiful.gap = beautiful.gap + 1 end ),
    awful.button({ }, 5, function() beautiful.gap = beautiful.gap + 1 end ),
}
-- }}}

-- {{{ Key bindings

awful.keyboard.append_global_keybindings {
	-- Volume control
	awful.key({}, "XF86AudioMute", function() awful.spawn("pamixer -t") end,
	{description = "mute volume", group = "Function Keys"}),
	awful.key({}, "XF86AudioLowerVolume", function() awful.spawn("pamixer -d 3") end,
	{description = "decrease volume", group = "Function Keys"}),
	awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn("pamixer -i 3") end,
	{description = "increase volume", group = "Function Keys"}),
	awful.key({}, "XF86AudioMicMute", function() awful.spawn("pamixer --default-source -t") end,
	{description = "mute microphone", group = "Function Keys"}),

	-- Brightness
	awful.key({}, "XF86MonBrightnessUp", function() awful.spawn("brightnessctl s +5%") end,
   	{description = "increase brightness", group = "Function Keys"}),
	awful.key({}, "XF86MonBrightnessDown", function() awful.spawn("brightnessctl s 5%-") end,
	{description = "decrease brightness", group = "Function Keys"}),

	awful.key({}, "XF86Display", function() xrandr.xrandr() end,
	{description = "Cycle through monitor configurations", group = "Function Keys"}),

	-- These are present on my keyboard and not bound to anything
	awful.key({}, "XF86Tools", function() end,
	{description = "⚠️ Unassingned", group = "Function Keys"}),
	awful.key({}, "XF86Search", function() end,
	{description = "⚠️ Unassingned", group = "Function Keys"}),
	awful.key({}, "XF86Search", function() end,
	{description = "⚠️ Unassingned", group = "Function Keys"}),
	awful.key({}, "XF86LaunchA", function() end,
	{description = "⚠️ Unassingned", group = "Function Keys"}),
	awful.key({}, "XF86Explorer", function() end,
	{description = "⚠️ Unassingned", group = "Function Keys"}),

	-- Playback control
	awful.key({}, "XF86AudioPlay", function() awful.spawn("playerctl play-pause") end,
	{description = "toggle playerctl", group = "Function Keys"}),
	awful.key({}, "XF86AudioPrev", function() awful.spawn("playerctl previous") end,
	{description = "playerctl previous", group = "Function Keys"}),
	awful.key({}, "XF86AudioNext", function() awful.spawn("playerctl next") end,
	{description = "playerctl next", group = "Function Keys"}),
}

-- General Awesome keys
awful.keyboard.append_global_keybindings({

-- Handy Scratchpads
  awful.key({modkey, "Control", "Shift"}, "s", function ()
    handy("spotify", awful.placement.centered, 0.9, 0.7) end,
    {description = "Open spotify in the center of the screen", group = "Handy Scratchpads"}),

    awful.key({ modkey }, "s", hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey }, "F1", hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    awful.key({ modkey, "Shift"   }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
    --           {description = "run prompt", group = "launcher"}),

    awful.key({ modkey, "Shift" }, "f", function () awful.spawn("flameshot gui") end,
              {description = "Screencapture with flameshot", group = "launcher"}),
    awful.key({ modkey }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "Return", function () run_once("obsidian") end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey }, " ",     function () awful.spawn("rofi-launcher") end,
              {description = "Launch Rofi", group = "launcher"}),
    awful.key({ modkey }, "a",     function () awful.spawn("misa") end,
              {description = "Launch Rofi", group = "launcher"}),
    awful.key({ modkey, "Control" }, " ",     function () awful.spawn("rofi -show emoji") end,
              {description = "😀 Rofi Emoji picker", group = "launcher"}),
    awful.key({ modkey, }, "n",     function () awful.spawn("rofi-todo") end,
              {description = " Rofi todoist quick add", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "n",     function () awful.spawn("tod_notification.sh") end,
              {description = " Rofi todoist show next task", group = "launcher"}),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, "Shift" }, "m",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
              {description = "restore minimized", group = "client"}),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "y", function () awful.layout.inc( 1)                end,
              {description = "select next layout", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "y", function () awful.layout.inc(-1)                end,
              {description = "select previous layout", group = "layout"}),
})


awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey, "Control" }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
        awful.key({ modkey,           }, "w",      function (c) c:kill()                         end,
                {description = "close", group = "client"}),
        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
                {description = "toggle floating", group = "client"}),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                {description = "move to master", group = "client"}),
        awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                {description = "move to screen", group = "client"}),
        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                {description = "toggle keep on top", group = "client"}),
        awful.key({ modkey,           }, "m",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end ,
            {description = "minimize", group = "client"}),
        awful.key({ modkey, "Control" }, "g",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "(un)maximize", group = "client"}),
        awful.key({ modkey, "Control" }, "v",
            function (c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end ,
            {description = "(un)maximize vertically", group = "client"}),
        awful.key({ modkey, "Control" }, "h",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end ,
            {description = "(un)maximize horizontally", group = "client"}),
    })
end)

-- }}}

