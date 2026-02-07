-- current-game/manager.lua

local entries = {
    {--1
        placeId = 0000000000,
        universeId = 000000,
        name = "Game",
        module = "https://example.com",
    }

local config = {
    byPlace = {},
    byUniverse = {},
}

for _, entry in ipairs(entries) do
    if entry.placeId then
        config.byPlace[entry.placeId] = entry
    end
    if type(entry.alternatePlaceIds) == "table" then
        for _, altId in ipairs(entry.alternatePlaceIds) do
            config.byPlace[altId] = entry
        end
    end
    if entry.universeId then
        config.byUniverse[entry.universeId] = entry
    end
end

return config
