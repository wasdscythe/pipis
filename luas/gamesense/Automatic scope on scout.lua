local references = {
    entity = {
        get_local_player = entity.get_local_player,
        get_player_weapon = entity.get_player_weapon,
        get_prop = entity.get_prop
    },
}

client.set_event_callback("setup_command", function(cmd)
    local local_player = references.entity.get_local_player()
    if local_player ~= nil then
        local local_player_weapon = references.entity.get_player_weapon(local_player)
        if local_player_weapon ~= nil then
            if references.entity.get_prop(local_player_weapon, "m_iItemDefinitionIndex") == 40 then
                if references.entity.get_prop(local_player_weapon, "m_zoomLevel") == 0 then
                    cmd.in_attack2 = 1
                end
            end
        end
    end
end)
