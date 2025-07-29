local references = {

    entity = {

        get_local_player = entity.get_local_player,
        is_alive = entity.is_alive,
        get_players = entity.get_players,
        get_prop = entity.get_prop,
        get_bounding_box = entity.get_bounding_box,
        get_player_name = entity.get_player_name
    },
    pairs = pairs,
    table = {

        insert = table.insert
    },
    renderer = {

        measure_text = renderer.measure_text,
        text = renderer.text
    },
    string = {

        format = string.format
    },
}

local colors = {
    [4] = {
        255,
        255,
        0
    },
    [5] = {
        255,
        128,
        0
    },
    [6] = {
        255,
        0,
        64
    }
}

client.set_event_callback("paint", function()
    local local_player = references.entity.get_local_player()
    if local_player ~= nil then
        local players = references.entity.get_players(false)

        if not references.entity.is_alive(local_player) then
            -- When Mommy tells me to cum I listen alr?
        else
            local local_player_team = references.entity.get_prop(local_player, "m_iTeamNum")
            local alive_teammates = 0
            local enemies = {}

            for _, player in references.pairs(players) do
                if references.entity.get_prop(player, "m_iTeamNum") == local_player_team then
                    alive_teammates = alive_teammates + 1
                else
                    references.table.insert(enemies, player)
                end
            end

            for _, enemy in references.pairs(enemies) do
                local kills = references.entity.get_prop(enemy, "m_iNumRoundKills")
                if kills < 4 then
                    goto continue
                end

                local x1, y1, x2, y2, alpha_multiplier = references.entity.get_bounding_box(enemy)
                if alpha_multiplier == 0 then
                    goto continue
                end

                local color = colors[kills > 6 and 6 or kills]

                local x, y = (x1 + x2) / 2, y1

                local _, name_height = references.renderer.measure_text(nil, references.entity.get_player_name(enemy))

                local text = references.string.format("%i/%i KILLSTREAK", kills, alive_teammates + kills)
                local text_width, text_height = references.renderer.measure_text(nil, text)

                references.renderer.text(x - text_width / 2, y - name_height - text_height, color.r, color.g, color.b, 255, nil, 0, text)

                ::continue::
            end
        end
    end
end)
