function is_terminal(c)
    return (c.class and c.class:match("term")) and true or false
end

function copy_size(c, parent_client)
    if not c or not parent_client then
        return
    end
    if not c.valid or not parent_client.valid then
        return
    end
    c.x=parent_client.x;
    c.y=parent_client.y;
    c.width=parent_client.width;
    c.height=parent_client.height;
end

client.connect_signal("manage", function(c)
    if is_terminal(c) then
        return
    end
    local parent_client=awful.client.focus.history.get(c.screen, 1)
    if parent_client and is_terminal(parent_client) then
        parent_client.child_resize=c
        parent_client.minimized = true

        c:connect_signal("unmanage", function() parent_client.minimized = false end)

        -- c.floating=true
        copy_size(c, parent_client)
    end
end)

