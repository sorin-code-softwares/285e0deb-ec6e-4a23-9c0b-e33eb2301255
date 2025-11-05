-- current-game/games/Murderers-VS-Sheriffs.lua
return function(Tab, Aurexis, Window, ctx)

    local function addScript(displayName, source, opts)
        opts = opts or {}

        local title = displayName
        if opts.subtext and #opts.subtext > 0 then
            title = title .. " — " .. opts.subtext
        end

        -- Beschreibung zusammensetzen
        if opts.recommended and not opts.description then
            opts.description = " | Good Script"
        end

        if opts.keyRequired then
            if opts.description then
                opts.description = opts.description .. " 🔑 Has a Key System"
            else
                opts.description = "🔑 Has a Key System"
            end
        end


        Tab:CreateButton({
            Name = title,
            Description = opts.description, -- nur wenn gesetzt
            Callback = function()
                local ok, err = pcall(function()
                    if opts.raw then
                        assert(type(source) == "string" and #source > 0, "empty raw source")
                        loadstring(source)()
                    else
                        local code = game:HttpGet(source)
                        assert(type(code) == "string" and #code > 0, "failed to fetch code")
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
            end
        })
    end

    ----------------------------------------------------------------

    local scripts = {
        { name = "Golden Hub", url = "https://pastefy.app/AxxGMYly/raw", description = "ESP, Speed ect" },
        { name = "vinhfat Hub", url = "https://gist.githubusercontent.com/vinhxdev/e92f38aeb4ac30416a00042008f11e52/raw/f30db37119ab0888d1738ac02012f92dc4876f25/main.lua", recommended = true },
    }
    
    -- Sort: recommended first, then alphabetically within group
    table.sort(scripts, function(a, b)
        if a.recommended ~= b.recommended then
            return a.recommended and not b.recommended
        end
        return a.name:lower() < b.name:lower()
    end)

    for _, s in ipairs(scripts) do
        addScript(
            s.name,
            s.url or s.raw,
            {
                subtext     = s.subtext,
                description = s.description,
                recommended = s.recommended, 
                keyRequired = s.keyRequired,
                raw         = (s.raw ~= nil)
            }
        )
    end
end
