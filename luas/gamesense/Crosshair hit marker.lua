local references = {
    client = {
        set_event_callback = client.set_event_callback,
        screen_size = client.screen_size,
        userid_to_entindex = client.userid_to_entindex
    },
    globals = {
        curtime = globals.curtime
    },
    math = {
        ceil = math.ceil
    },
    renderer = {
        texture = renderer.texture
    },
    entity = {
        get_local_player = entity.get_local_player
    }
}

local colors = {
    red = {
        255,
        0,
        64
    },
    yellow = {
        255,
        255,
        0
    },
    orange = {
        255,
        128,
        0
    },
    white = {
        255,
        255,
        255
    }
}

local hit_marker = {
    curtime = 0,
    color = colors.white,
    texture = renderer.load_png(require("gamesense/base64").decode("iVBORw0KGgoAAAANSUhEUgAAABcAAAAXCAYAAADgKtSgAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAjklEQVRIie2VMQ6AIAwAq/+ifNg+TD9xDkpCAA1qTRxswkLbuwVaAQxQQByPAiZAABZHgSZeuvASaM7JE08FCsx5f1lwV1CBW/A7ggQOZe6oIbC9oh64tcCADIC8FeNr5B/+w78PDyJinYxpr6/jZLbEzu8fe2fLVfCpwAN8KPBaFE2BJ7gSpHnsvf0jYCv0MqP5zn//WgAAAABJRU5ErkJggg=="), 23, 23)
}

references.client.set_event_callback("paint", function()
    local time_elapsed = globals.curtime() - hit_marker.curtime
    
    if time_elapsed >= 0 and time_elapsed <= 0.5 then
        local screen_width, screen_height = references.client.screen_size()

        references.renderer.texture(hit_marker.texture, screen_width / 2 - 11, screen_height / 2 - 11, 23, 23, hit_marker.color[1], hit_marker.color[2], hit_marker.color[3], references.math.ceil(510 * (0.5 - time_elapsed)), "f")
    end
end)

references.client.set_event_callback("player_hurt", function(e)
    local local_player = references.entity.get_local_player()

    if local_player ~= references.client.userid_to_entindex(e.userid) and local_player == references.client.userid_to_entindex(e.attacker) then
        if e.hitgroup == 1 then
            hit_marker.color = colors.red
        elseif e.health == 0 then
            hit_marker.color = colors.yellow
        elseif e.weapon == "inferno" then
            hit_marker.color = colors.orange
        else
            hit_marker.color = colors.white
        end

        hit_marker.curtime = references.globals.curtime()
    end
end)
