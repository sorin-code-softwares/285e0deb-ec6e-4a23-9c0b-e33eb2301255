-- current-game/manager.lua
-- Configure per-game modules keyed by PlaceId and/or UniverseId (GameId).
-- Each entry can also provide alternate place ids for shared universes.

local entries = {
    {
        placeId = 7711635737,
        universeId = 2992873140,
        name = "Emergency Hamburg",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/EmergencyHamburg.lua",
    },
    {
        placeId = 5829141886,
        universeId = 2073329983,
        name = "RealisticCarDriving",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/RealisticCarDriving.lua",
    },
    {
        placeId = 126509999114328,
        universeId = 7326934954,
        name = "99 Nights In The Forest",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/99NightsInTheForest.lua",
    },
    {
        placeId = 123821081589134,
        universeId = 7848646653,
        name = "Break your Bones",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/BreakYourBones.lua",
    },
    {
        placeId = 96342491571673,
        universeId = 7709344486,
        name = "Steal a Brainrot",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/Steal%20a%20Brainrot.lua",
    },
    {
        placeId = 2768379856,
        universeId = 1000233041,
        name = "3008 [2.73]",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/3008.lua",
    },
    {
        placeId = 8737899170,
        universeId = 3317771874,
        name = "Pet Simulator 99",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/PS99.lua",
    },
    {
        placeId = 18901165922,
        universeId = 6401952734,
        name = "Pets Go!",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/PetsGo.lua",
    },
    {
        placeId = 6516141723,
        alternatePlaceIds = { 6839171747 },
        universeId = 2440500124,
        name = "DOORS",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/Doors.lua",
    },
    {
        placeId = 7305309231,
        universeId = 2851381018,
        name = "Taxi Boss",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/TaxiBoss.lua",
    },
    {
        placeId = 16281300371,
        universeId = 4777817887,
        name = "Blade-Ball",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/BladeBall.lua",
    },
    {
        placeId = 17474746614,
        universeId = 5980808883,
        name = "7 Days To Live",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/7DaysToLive.lua",
    },
    {
        placeId = 127742093697776,
        universeId = 8316902627,
        name = "Plants vs Brainrots",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/PlantsVSBrainrots.lua",
    },
    {
        placeId = 286090429,
        universeId = 111958650,
        name = "Arsenal",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/Arsenal.lua",
    },
    {
        placeId = 16389395869,
        universeId = 5650396773,
        name = "a dusty trip",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/ADustyTrip.lua",
    },
    {
        placeId = 11276071411,
        universeId = 4019583467,
        name = "NPC or DIE",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/NPC-or-DIE.lua",
    },
    {
        placeId = 99827026339186,
        universeId = 8796373417,
        name = "Slasher Blade Loot",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/Slasher-Blade-Loot.lua",
    },
    {
        placeId = 11966456877,
        universeId = 4234745929,
        name = "Answer or Die",
        module = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/games/Answer-Or-Die.lua",
    },
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
