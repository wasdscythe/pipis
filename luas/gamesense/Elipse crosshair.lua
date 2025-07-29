local references = {
    entity = {
        get_local_player = entity.get_local_player,
        is_alive = entity.is_alive
    },
    client = {
        screen_size = client.screen_size
    },
    renderer = {
        texture = renderer.texture
    }
}

local elipse = renderer.load_png(require("gamesense/base64").decode("iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAACXBIWXMAAC4jAAAuIwF4pT92AAAAR0lEQVQImS3MoREDMRAEME0K+VR7zMjl/IOwTPo5E6MNMRITXLjRxwueqkp3p6qCD/TeO0nS3cF+4TfGsNYy54SvczxYx/cfyJYlKcuMTAYAAAAASUVORK5CYIKUotaaIkKtNZVSBFT2qwpcwHezSuIHyRJeCPgjVesAAAAASUVORK5CYII="), 5, 5)

client.set_event_callback("paint_ui", function()
    if references.entity.is_alive(references.entity.get_local_player()) then
        local screen_width, screen_height = references.client.screen_size()
        
        references.renderer.texture(elipse, screen_width / 2 - 2, screen_height / 2 - 2, 5, 5, 255, 255, 255, 255, "f")
    end
end)
