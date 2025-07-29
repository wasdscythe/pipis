local references = {
    client = {
        userid_to_entindex = client.userid_to_entindex
    },
    entity = {
        get_local_player = entity.get_local_player,
        hitbox_position = entity.hitbox_position
    },
    globals = {
        tickcount = globals.tickcount,
        curtime = globals.curtime
    },
    table = {
        insert = table.insert
    },
    pairs = pairs,
    renderer = {
        world_to_screen = renderer.world_to_screen,
        texture = renderer.texture
    },
    math = {
        huge = math.huge,
        sqrt = math.sqrt
    },
}

local ffi = require("ffi")

ffi.cdef[[
    typedef struct {
        float x;
        float y;
        float z;
    } Vector;
    typedef struct {
        float x;
        float y;
        float z;
    } QAngle;
]]

local AddBoxOverlay = ffi.cast("void(__thiscall*)(void*, const Vector&, const Vector&, const Vector&, QAngle const&, int, int, int, int, float)", ffi.cast("void***", client.create_interface("engine.dll", "VDebugOverlay004"))[0][1])

local mins, max, angles = ffi.new("Vector", {-2, -2, -2}), ffi.new("Vector", {2, 2, 2}), ffi.new("QAngle", {0, 0, 0})

local texture = renderer.load_png(require("gamesense/base64").decode("iVBORw0KGgoAAAANSUhEUgAAABcAAAAXCAYAAADgKtSgAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAjklEQVRIie2VMQ6AIAwAq/+ifNg+TD9xDkpCAA1qTRxswkLbuwVaAQxQQByPAiZAABZHgSZeuvASaM7JE08FCsx5f1lwV1CBW/A7ggQOZe6oIbC9oh64tcCADIC8FeNr5B/+w78PDyJinYxpr6/jZLbEzu8fe2fLVfCpwAN8KPBaFE2BJ7gSpHnsvf0jYCv0MqP5zn//WgAAAABJRU5ErkJggg=="), 23, 23)

local hitgroups = {
    {0, 1},
    {4, 5, 6},
    {2, 3},
    {13, 15, 16},
    {14, 17, 18},
    {7, 9, 11},
    {8, 10, 12}
}

local shots = {}

client.set_event_callback("bullet_impact", function(e)
    if references.client.userid_to_entindex(e.userid) == references.entity.get_local_player() then
        AddBoxOverlay(AddBoxOverlay, ffi.new("Vector", {e.x, e.y, e.z}), mins, max, angles, 0, 0, 255, 255, 4)

        local tickcount = references.globals.tickcount()

        if shots[tickcount] == nil then
            shots[tickcount] = {
                bullet_impacts = {},
                endtime = 0
            }
        end

        references.table.insert(shots[tickcount].bullet_impacts, {
            x = e.x,
            y = e.y,
            z = e.z
        })
    end
end)

client.set_event_callback("paint", function()
    for tick, shot in references.pairs(shots) do
        if references.globals.curtime() < shot.endtime then
            local x, y = references.renderer.world_to_screen(shot.x, shot.y, shot.z)
            if x ~= nil and y ~= nil then
                references.renderer.texture(texture, x - 11, y - 11, 23, 23, 255, 255, 255, 255, "f")
            end
        end
    end
end)

client.set_event_callback("player_hurt", function(e)
    if references.client.userid_to_entindex(e.attacker) == references.entity.get_local_player() then
        local tickcount = references.globals.tickcount()

        if shots[tickcount] ~= nil and hitgroups[e.hitgroup] ~= nil then
            local victim = references.client.userid_to_entindex(e.userid)
            local bullet_impact_closest = references.math.huge
            local bullet_impact_hit = nil

            for _, bullet_impact in references.pairs(shots[tickcount].bullet_impacts) do
                for _, hitbox in references.pairs(hitgroups[e.hitgroup]) do
                    local hitbox_position_x, hitbox_position_y, hitbox_position_z = references.entity.hitbox_position(victim, hitbox)
                    local distance = references.math.sqrt((bullet_impact.x - hitbox_position_x) ^ 2 + (bullet_impact.y - hitbox_position_y) ^ 2 + (bullet_impact.z - hitbox_position_z) ^ 2)

                    if distance < bullet_impact_closest then
                        bullet_impact_closest = distance
                        bullet_impact_hit = bullet_impact
                    end
                end
            end

            if bullet_impact_hit ~= nil then
                shots[tickcount] = {
                    endtime = references.globals.curtime() + 4,
                    x = bullet_impact_hit.x,
                    y = bullet_impact_hit.y,
                    z = bullet_impact_hit.z,
                }
            end
        end
    end
end)

client.set_event_callback("round_start", function(e)
    shots = {}
end)
