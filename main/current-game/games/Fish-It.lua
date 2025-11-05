-- current-game/games/GAMENAME.lua
return function(Tab, Aurexis, Window, ctx)

    local function addScript(displayName, source, opts)
        opts = opts or {}

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
        { name = "Frxser Hub", url = "https://pastebin.com/raw/7p93Wzi9", description = "Key: deffendersnemo" },
        { name = "717exe - Fish It",   url = "https://raw.githubusercontent.com/arcadeisreal/717exe---Fish-It/refs/heads/main/loader.lua"  },
        { name = "Chloe X",  url = "https://raw.githubusercontent.com/MajestySkie/Chloe-X/main/Main/ChloeX", description = "Good Script. Doesn´t work on Exec like Solara"},
        { name = "BebasScripter", url = "https://gist.githubusercontent.com/OmarBinLadek/e8224cc7ed5faae9767235b3a978ed44/raw/569ca6b703826253068f015bbe465a1093f8cda9/usethisautokraken.lua"},
        { name = "Project Madara", url = "https://raw.githubusercontent.com/IsThisMe01/Project-Madara/refs/heads/main/loader.lua"},


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
   
