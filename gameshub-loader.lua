-- 1) Load AurexisInterface Library
local Aurexis = loadstring(game:HttpGet("https://raw.githubusercontent.com/Wyattluber/shub_unstable/main/AurexisLib/main.lua"))()

-- Toggle key store (backed by Aurexis library)
local toggleStore
do
    local service = Aurexis and Aurexis.ToggleKeyService
    if type(service) == "table" and type(service.new) == "function" then
        toggleStore = service.new({
            folder = "SorinHubConfig",
            file = "interface-toggle.txt",
            envKey = "__SorinHubToggleKey",
        })

        -- optional: keep backwards-compatible global handle
        if toggleStore and type(toggleStore.expose) == "function" then
            toggleStore:expose("SorinHubToggleKeyStore")
        end
    end
end

-- Safe wrappers for optional API
local function try(fn, ...)
    local ok, res = pcall(fn, ...)
    return ok, res
end

-- 2) Build window (we'll briefly hide it while we preload)
local Window = Aurexis:CreateWindow({
    Name = "Sorin Script Hub",
    Subtitle = "SorinSoftwares",
    LoadingEnabled = true,
    ConfigSettings = { RootFolder = nil, 
    ConfigFolder = "SorinHubConfig" },
    KeySystem = false,
})

do
    local savedToggle
    if toggleStore and type(toggleStore.load) == "function" then
        savedToggle = toggleStore:load()
    end
    if savedToggle and type(Window) == "table" and typeof(Window.SetToggleBind) == "function" then
        local ok, success, message = pcall(Window.SetToggleBind, Window, savedToggle)
        if not ok then
            warn("[SorinHub] Failed to apply saved toggle key:", success)
        elseif not success then
            warn("[SorinHub] Saved toggle key rejected:", message)
        end
    end
end
-- try to hide while we fetch (if supported)
try(function() Window:SetVisible(false) end)
try(function() Window:SetMinimized(true) end)

-- Quick notify (will show once visible)
Aurexis:Notification({ Title="Sorin Script Hub", Icon="emoji_emotions", ImageSource="Material", Content="Have A Nice Day :D" })

-- 3) Remote modules
local TABS = {
    FEScripts        = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/FE-Scripts.lua",
    UniversalScripts = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/UniversalScripts.lua",
    HubInfo          = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/HubInfo.lua",
    VisualsGraphics  = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/visuals_and_graphics.lua",
    CurrentGame      = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/game-loader.lua",
    ManagerCfg       = "https://scripts.sorinservice.online/sorin/game-manager",
    Dev              = "https://raw.githubusercontent.com/sorin-code-softwares/285e0deb-ec6e-4a23-9c0b-e33eb2301255/main/main/current-game/Developer.lua"
}

-- 4) Helpers (no cachebusters on raw)
local function safeRequire(url)
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if not ok then return nil, "HttpGet failed: " .. tostring(body) end
    local fn, lerr = loadstring(body)
    if not fn then return nil, "loadstring failed: " .. tostring(lerr) end
    local ok2, res = pcall(fn)
    if not ok2 then return nil, "module pcall failed: " .. tostring(res) end
    return res
end

local function attachTab(name, url, icon, ctx)
    local Tab = Window:CreateTab({ Name = name, Icon = icon or "sparkle", ImageSource = "Material", ShowTitle = true })
    local mod, err = safeRequire(url)
    if not mod then
        Tab:CreateLabel({ Text = "Error loading '"..name.."': "..tostring(err), Style = 3 })
        return
    end
    local ok, msg = pcall(mod, Tab, Aurexis, Window, ctx) -- pass ctx through
    if not ok then
        Tab:CreateLabel({ Text = "Init error '"..name.."': "..tostring(msg), Style = 3 })
    end
end

-- 5) Preload manager ONCE, compute ctx & title (PlaceId or UniverseId)
local currentGameTitle = "Current Game"
local preCtx = nil do
    local cfg, err = safeRequire(TABS.ManagerCfg)
    if cfg and type(cfg) == "table" then
        local placeId = game.PlaceId
        local universeId = game.GameId
        local entry = nil

        if type(cfg.byPlace) == "table" then
            entry = cfg.byPlace[placeId]
        end
        if not entry and type(cfg.byUniverse) == "table" then
            entry = cfg.byUniverse[universeId]
        end

        if entry then
            preCtx = {
                name = entry.name,
                module = entry.module,
                placeId = entry.placeId or placeId,
                universeId = entry.universeId or universeId,
            }
            if entry.name and #entry.name > 0 then
                currentGameTitle = entry.name
            end
        end
    end
end

-- 6) Home tab last
Window:CreateHomeTab()

-- 7) Create tabs (now they'll appear already titled & populated)
attachTab("Universal Scripts",  TABS.UniversalScripts, "admin_panel_settings")
attachTab("FE Scripts",         TABS.FEScripts,        "insert_emoticon") 
attachTab("Visuals & Graphics", TABS.VisualsGraphics,  "remove_red_eye")
attachTab("Hub Info",           TABS.HubInfo,          "info")
attachTab("Dev",                TABS.Dev,              "settings")

-- Dynamisches Icon je nach Support
local currentIcon = preCtx and "data_usage" or "_error_outline"
attachTab(currentGameTitle, TABS.CurrentGame, currentIcon, preCtx)


-- Show window now that we’re done
try(function() Window:SetMinimized(false) end)
try(function() Window:SetVisible(true) end)
