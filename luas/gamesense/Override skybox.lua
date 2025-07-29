local references = {
    client = {
        userid_to_entindex = client.userid_to_entindex
    },
    entity = {
        get_local_player = entity.get_local_player
    }
}

local ffi = require("ffi")

local R_LoadNamedSkys = ffi.cast(ffi.typeof("bool(__fastcall*)(const char*)"), client.find_signature("engine.dll", "\x55\x8B\xEC\x81\xEC\xCC\xCC\xCC\xCC\x56\x57\x8B\xF9\xC7\x45"))

client.set_event_callback("player_connect_full", function(e)
    if references.client.userid_to_entindex(e.userid) == references.entity.get_local_player() then
        R_LoadNamedSkys("cs_baggage_skybox_")
    end
end)

R_LoadNamedSkys("cs_baggage_skybox_")
