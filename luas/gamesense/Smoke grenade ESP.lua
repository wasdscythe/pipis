local references = {
    ui = {
        get = ui.get
    },
    entity = {
        get_all = entity.get_all,
        get_origin = entity.get_origin
    },
    pairs = pairs,
    renderer = {
        world_to_screen = renderer.world_to_screen,
        text = renderer.text
    }
}

local dropped_weapons = {
    ui.reference("VISUALS", "Other ESP", "Dropped weapons")
}

client.set_event_callback("paint", function()
    local r, g, b, a = references.ui.get(dropped_weapons[2])

    for _, smoke in references.pairs(entity.get_all("CSmokeGrenadeProjectile")) do
        local origin_x, origin_y, origin_z = references.entity.get_origin(smoke)
        local screen_x, screen_y = references.renderer.world_to_screen(origin_x, origin_y, origin_z)

        if screen_x ~= nil then
            references.renderer.text(screen_x, screen_y, r, g, b, a, "-c", 0, "SMOKE")
        end
    end
end)
