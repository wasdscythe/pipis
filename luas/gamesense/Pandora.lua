local references = {
    ui = {
        reference = ui.reference,
        get = ui.get
    },
    entity = {
        get_local_player = entity.get_local_player,
        is_alive = entity.is_alive
    },
    client = {
        screen_size = client.screen_size
    },
    renderer = {
        text = renderer.text,
        measure_text = renderer.measure_text
    },
    pairs = pairs,
    type = type
}

local indicators = {
    {
        reference = ui.reference("RAGE", "Aimbot", "Force safe point"),
        text = "fsp"
    },
    {
        reference = ui.reference("RAGE", "Aimbot", "Force body aim"),
        text = "fba"
    },
    {
        reference = {
            ui.reference("MISC", "Miscellaneous", "Ping spike"),
        },
        text = "ps"
    },
    {
        reference = {
            ui.reference("RAGE", "Aimbot", "Double tap")
        },
        text = "dt"
    },
    {
        reference = ui.reference("RAGE", "Other", "Duck peek assist"),
        text = "dpa"
    },
    {
        reference = {
            ui.reference("AA", "Anti-aimbot angles", "Freestanding")
        },
        text = "f"
    },
    {
        reference = {
            ui.reference("AA", "Other", "On shot anti-aim")
        },
        text = "osaa"
    },
    {
        reference = {
            ui.reference("RAGE", "Aimbot", "Minimum damage override")
        },
        text = "mdo"
    }
}

client.set_event_callback("paint", function()
    local local_player = references.entity.get_local_player()
    if local_player ~= nil then
        if references.entity.is_alive(local_player) then
            local screen_width, screen_height = references.client.screen_size()
            local x, y = screen_width / 2 + 5, screen_height / 2 + 20

            references.renderer.text(x, y, 191, 204, 255, 255, "b", 0, "pandora")
            local _, pandora_text_height = references.renderer.measure_text("b", "pandora")
            y = y + pandora_text_height

            for _, indicator in references.pairs(indicators) do
                if references.type(indicator.reference) == "table" then
                    if not references.ui.get(indicator.reference[1]) or not references.ui.get(indicator.reference[2]) then
                        goto continue
                    end
                elseif not references.ui.get(indicator.reference) then
                    goto continue
                end

                references.renderer.text(x, y, 255, 255, 255, 255, nil, 0, indicator.text)
                local _, text_height = references.renderer.measure_text(nil, indicator.text)
                y = y + text_height

                ::continue::
            end
        end
    end
end)
