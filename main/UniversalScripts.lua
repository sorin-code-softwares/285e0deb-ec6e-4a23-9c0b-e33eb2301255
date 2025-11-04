-- UniversalScripts.lua
return function(Tab, Aurexis, Window, ctx)

    local function addScript(displayName, source, opts)
    opts = opts or {}

    -- Titel mit Subtext
    local title = displayName
    if opts.subtext and #opts.subtext > 0 then
        title = title .. " — " .. opts.subtext
    end

    -- Beschreibung zusammensetzen
    if opts.recommended and not opts.description then
        opts.description = "✓ Recommended by Sorin"
    end

    if opts.keyRequired then
        if opts.description then
            opts.description = opts.description .. " 🔑 Has a Key System"
        else
            opts.description = "🔑 Has a Key System"
        end
    end

    local isRawSource = opts.isRaw or opts.raw == true

    Tab:CreateButton({
        Name = title,
        Description = opts.description,
        Callback = function()
            task.spawn(function()
                Aurexis:Notification({
                    Title = displayName .. " is being executed",
                    Icon = "info",
                    ImageSource = "Material",
                    Content = "Please wait..."
                })

                local ok, err = pcall(function()
                    if isRawSource then
                        assert(type(source) == "string" and #source > 0, "missing inline source")
                        loadstring(source)()
                    else
                        assert(type(source) == "string" and #source > 0, "missing script URL")
                        local code = game:HttpGet(source)
                        assert(type(code) == "string" and #code > 0, "received empty script response")
                        loadstring(code)()
                    end
                end)

                if ok then
                    Aurexis:Notification({
                        Title = displayName,
                        Icon = "check_circle",
                        ImageSource = "Material",
                        Content = "Executed successfully!"
                    })
                else
                    Aurexis:Notification({
                        Title = displayName,
                        Icon = "error",
                        ImageSource = "Material",
                        Content = "Error: " .. tostring(err)
                    })
                end
            end)
        end
    })
end


    ----------------------------------------------------------------
    Tab:CreateParagraph({
        Title = "Why The List Is Small",
        Text = "Every universal script is checked for functionality before we add it. That review step keeps the list short right now, but new picks drop routinely once they pass testing."
    })

    ----------------------------------------------------------------
    -- Main Scripts
    Tab:CreateSection("Main Scripts")
    local mainScripts = {
        { name = "Express Hub",                  url = "https://api.luarmor.net/files/v3/loaders/d8824b23a4d9f2e0d62b4e69397d206b.lua", keyRequired = true },
        { name = "Foggy Hub",                    url = "https://raw.githubusercontent.com/FOGOTY/foggy-loader/refs/heads/main/loader", keyRequired = true },
        { name = "Sirius",                       url = "https://sirius.menu/script" },
        { name = "Wisl'i Universal Project",     url = "https://raw.githubusercontent.com/wisl884/wisl-i-Universal-Project1/main/Wisl'i%20Universal%20Project.lua" },
        { name = "FE Trolling GUI (Script Hub)", url = "https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub/main/FE%20Trolling%20GUI.luau" },
        { name = "Sky Hub",                      url = "https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub/main/SkyHub.txt" }
    }
    table.sort(mainScripts, function(a, b)
        return a.name:lower() < b.name:lower()
    end)
    for _, script in ipairs(mainScripts) do
        addScript(script.name, script.url or script.raw, {
            subtext     = script.subtext,
            description = script.description,
            recommended = script.recommended,
            isRaw       = script.raw ~= nil
        })
    end

    ----------------------------------------------------------------
    -- Admin Scripts
    Tab:CreateSection("Admin Scripts")
    local adminScripts = {
        { name = "Infinite Yield",       url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", description = "FE Admin Script", recommended = true },
        { name = "Nameless Admin",       url = "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"},
        { name = "Strawberry Admin CMD", url = "https://raw.githubusercontent.com/C-Dr1ve/Strawberry/refs/heads/main/Current_Version.lua" },
        { name = "Cmd",                  url = "https://raw.githubusercontent.com/lxte/cmd/main/main.lua" },
        { name = "Fates Admin",          url = "https://raw.githubusercontent.com/fatesc/fates-admin/main/main.lua" },
        { name = "Reviz Admin V2",       url = "https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub/main/Reviz%20AdminV2" }
    }
    table.sort(adminScripts, function(a, b)
        return a.name:lower() < b.name:lower()
    end)
    for _, script in ipairs(adminScripts) do
        addScript(script.name, script.url or script.raw, {
            subtext     = script.subtext,
            description = script.description,
            recommended = script.recommended,
            isRaw       = script.raw ~= nil
        })
    end

    ----------------------------------------------------------------
    -- Aimbots + Silent Aim
    Tab:CreateSection("Aimbots + Silent Aim")
    local aimScripts = {
        { name = "Universal Aimbot", url = "https://pastebin.com/raw/V16qnfcj" },
        { name = "Volcano Aimbot",   url = "https://pastebin.com/raw/6Rze0HJk" }
    }
    table.sort(aimScripts, function(a, b)
        return a.name:lower() < b.name:lower()
    end)
    for _, script in ipairs(aimScripts) do
        addScript(script.name, script.url or script.raw, {
            subtext     = script.subtext,
            description = script.description,
            recommended = script.recommended,
            isRaw       = script.raw ~= nil
        })
    end

    ----------------------------------------------------------------
    -- ESP Scripts
    Tab:CreateSection("ESP Scripts")
    local espScripts = {
        { name = "Sorin ESP",  url = "https://scripts.sorinservice.online/sorin/ESP.lua", description = "Easy ESP. Currently no UI. Toggle with 'f4'." },
        { name = "1MS ESP",    url = "https://raw.githubusercontent.com/Veyronxs/Universal/refs/heads/main/1ms_Esp_New", recommended = true }
    }
    table.sort(espScripts, function(a, b)
        return a.name:lower() < b.name:lower()
    end)
    for _, script in ipairs(espScripts) do
        addScript(script.name, script.url or script.raw, {
            subtext     = script.subtext,
            description = script.description,
            recommended = script.recommended,
            isRaw       = script.raw ~= nil
        })
    end

    ----------------------------------------------------------------
    -- Utility Tools
    Tab:CreateSection("Utility Tools")
    local utilityScripts = {
        { name = "Dex Explorer",     url = "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua" },
        { name = "Remotespy",        url = "https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua" },
        { name = "Audiologger",      url = "https://raw.githubusercontent.com/infyiff/backup/main/audiologger.lua" },
        { name = "Animation Logger", url = "https://raw.githubusercontent.com/Mautiku/ehh/main/sussy's%20animation%20logger.txt" },
        { name = "Image Logger",     url = "https://raw.githubusercontent.com/frzfrsy/decallogger/main/source" }
    }
    table.sort(utilityScripts, function(a, b)
        return a.name:lower() < b.name:lower()
    end)
    for _, script in ipairs(utilityScripts) do
        addScript(script.name, script.url or script.raw, {
            subtext     = script.subtext,
            description = script.description,
            recommended = script.recommended,
            isRaw       = script.raw ~= nil
        })
    end

    ----------------------------------------------------------------
    -- Automatizations
    Tab:CreateSection("Automatizations")
    local autoScripts = {
        { name = "Talentless",    url = "https://raw.githubusercontent.com/hellohellohell012321/TALENTLESS/main/TALENTLESS", description = "Best Piano Autoplayer! | ✓ Recommended by Sorin" },
        { name = "Stream Sniper", url = "https://raw.githubusercontent.com/Guest3D/ZirconHub/refs/heads/main/StreamSniper.lua" }
    }
    table.sort(autoScripts, function(a, b)
        return a.name:lower() < b.name:lower()
    end)
    for _, script in ipairs(autoScripts) do
        addScript(script.name, script.url or script.raw, {
            subtext     = script.subtext,
            description = script.description,
            recommended = script.recommended,
            isRaw       = script.raw ~= nil
        })
    end

    ----------------------------------------------------------------
    -- Other Stuff
    Tab:CreateSection("All other Stuff")
    local miscScripts = {
        { name = "Script Blox Searcher UI", url = "https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/ScriptSearcher" },
        { name = "Universal Spectator",     url = "https://pastebin.com/raw/LN2DPwSG" },
        { name = "TP to players",           url = "https://raw.githubusercontent.com/khenn791/script-khen/refs/heads/main/TeleportPlayers" },
        { name = "Hitbox Expander",         url = "https://pastebin.com/raw/VDf27cXR" }
    }
    table.sort(miscScripts, function(a, b)
        return a.name:lower() < b.name:lower()
    end)
    for _, script in ipairs(miscScripts) do
        addScript(script.name, script.url or script.raw, {
            subtext     = script.subtext,
            description = script.description,
            recommended = script.recommended,
            isRaw       = script.raw ~= nil
        })
    end
end
