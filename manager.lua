-- current-game/manager.lua
-- Configure per-game modules keyed by PlaceId and/or UniverseId (GameId).
-- Each entry can also provide alternate place ids for shared universes.

local entries = {
    {--1
        placeId = 135856908115931,
        universeId = 7219654364,
        name = "[DUELS] Mörder VS Sheriffs",
        module = "https://scripts.sorinservice.online/games/Murders-VS-Sheriffs",
    },
    {--2
        placeId = 2768379856,
        universeId = 1000233041,
        name = "3008 [2.73]",
        module = "https://scripts.sorinservice.online/games/3008.lua",
    },
    {--3
        placeId = 17474746614,
        universeId = 5980808883,
        name = "7 Days To Live",
        module = "https://scripts.sorinservice.online/games/7-days-to-live",
    },
    {--4
        placeId = 126509999114328,
        universeId = 7326934954,
        name = "99 Nights In The Forest",
        module = "https://scripts.sorinservice.online/games/99-nights-in-the-forest",
    },
    {--5
        placeId = 16389395869,
        universeId = 5650396773,
        name = "A dusty Trip",
        module = "https://scripts.sorinservice.online/games/a-dusty-trip",
    },
    {--6
        placeId = 11966456877,
        universeId = 4234745929,
        name = "Answer or Die",
        module = "https://scripts.sorinservice.online/games/answer-or-die",
    },
    {--7
        placeId = 286090429,
        universeId = 111958650,
        name = "Arsenal",
        module = "https://scripts.sorinservice.online/games/arsenal",
    },
    {--8
        placeId = 16281300371,
        universeId = 4777817887,
        name = "Blade-Ball",
        module = "https://scripts.sorinservice.online/games/blade-ball",
    },
    {--9
        placeId = 123821081589134,
        universeId = 7848646653,
        name = "Break your Bones",
        module = "https://scripts.sorinservice.online/games/break-your-bones",
    },
    {--10
        placeId = 2551991523,
        universeId = 911750776,
        name = "Broken Bones IV",
        module = "https://scripts.sorinservice.online/games/broken-bones-iv",
    },
    {--11
        name = "Brookhaven",
        module = "https://scripts.sorinservice.online/games/brookhaven",
    },
    {--12
        placeId = 654732683,
        universeId = 274816972,
        name = "Car Crushers 2 ",
        module = "https://scripts.sorinservice.online/games/car-crushers-2-",
    },
    {--13
        placeId = 6516141723,
        universeId = 2440500124,
        name = "DOORS",
        module = "https://scripts.sorinservice.online/games/doors",
        alternatePlaceIds = { 6839171747 },
    },
    {--14
        placeId = 125723653259639,
        universeId = 7204130482,
        name = "Drill Digging Simulator",
        module = "https://scripts.sorinservice.online/games/drill-digging-simulator",
    },
    {--15
        placeId = 7711635737,
        universeId = 2992873140,
        name = "Emergency Hamburg",
        module = "https://scripts.sorinservice.online/games/emergency-hamburg",
    },
    {--16
        name = "Fish It",
        module = "https://scripts.sorinservice.online/games/fish-it",
    },
    {--17
        name = "Forsaken",
        module = "https://scripts.sorinservice.online/games/forsaken",
    },
    {--18
        name = "Lumber Tycoon 2",
        module = "https://scripts.sorinservice.online/games/lumber-tycoon-2",
    },
    {--19
        name = "Murder Mystery 2",
        module = "https://scripts.sorinservice.online/games/murder-mystery-2",
    },
    {--20
        name = "NPC or DIE",
        module = "https://scripts.sorinservice.online/games/npc-or-die",
    },
    {--21
        name = "Pet Simulator 99",
        module = "https://scripts.sorinservice.online/games/pet-simulator-99",
    },
    {--22
        name = "Pets Go!",
        module = "https://scripts.sorinservice.online/games/pets-go-",
    },
    {--23
        name = "Plants vs Brainrots",
        module = "https://scripts.sorinservice.online/games/plants-vs-brainrots",
    },
    {--24
        name = "RealisticCarDriving",
        module = "https://scripts.sorinservice.online/games/realisticcardriving",
    },
    {--25
        name = "Slasher-Blade-Loot-W6",
        module = "https://scripts.sorinservice.online/games/slasher-blade-loot-w6",
    },
    {--26
        name = "Steal a Brainrot",
        module = "https://scripts.sorinservice.online/games/steal-a-brainrot",
    },
    {--27
        name = "Taxi Boss",
        module = "https://scripts.sorinservice.online/games/taxi-boss",
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
