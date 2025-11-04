-- exec.lua
return function(Tab, Aurexis, Window, ctx)

    local function addScript(displayName, source, opts)
        opts = opts or {}

        local title = displayName
        if opts.subtext and opts.subtext ~= "" then
            title = title .. " - " .. opts.subtext
        end

        local description = opts.description
        if (description == nil or description == "") and opts.recommended then
            description = "Recommended by Sorin"
        end

        local isRawSource = opts.isRaw or opts.raw == true

        Tab:CreateButton({
            Name = title,
            Description = description,
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
                            if type(source) ~= "string" or source == "" then
                                error("missing inline source")
                            end
                            loadstring(source)()
                        else
                            if type(source) ~= "string" or source == "" then
                                error("missing script URL")
                            end
                            local code = game:HttpGet(source)
                            if type(code) ~= "string" or code == "" then
                                error("received empty script response")
                            end
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
    -- PC Executors
    Tab:CreateSection("PC Executors")
    local mainScripts = {
        { name = "Synanpse X",    url = "https://raw.githubusercontent.com/AZYsGithub/Chillz-s-scripts/main/Synapse-X-Remake.lua"},
        { name = "Electron",      url = "https://rawscripts.net/raw/Universal-Script-Electron-UI-Remake-13807"},
        { name = "Internal Exec", url = "https://raw.githubusercontent.com/InfernusScripts/Other-Stuff/main/ExecutorInternal.lua"},

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
    -- Mobile Executors
    Tab:CreateSection("Mobile Executors")
    local aimScripts = {
        { name = "KRNL",        url = "https://raw.githubusercontent.com/AZYsGithub/Chillz-s-scripts/refs/heads/main/KRNL%20UI%20Remake.lua" },
        { name = "Arceus X",    url = "https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/Arceus%20X%20V3" },
        { name = "Delta (Old)", url = "https://raw.githubusercontent.com/ElijahGamingRBLX/Roblox-Executor/8536d27eef4eca985572dc30fc146dfd4e55a893/DeltaExecutor.lua" },
        { name = "Apple-Ware",  url = "https://raw.githubusercontent.com/TableDevelopments/public/e89d51c0c0c414f7b0263c68983d8564543b7771/ui.lua" },
        { name = "Cubix",       url = "https://github.com/1dontgiveaf/testscript69/raw/main/Cubix" },
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
end
