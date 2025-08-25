-- CONFIG --
roleList = Config.RoleList;

-- GLOBALS --
timeTracker = {}
hasPerms = {}
permTracker = {}
activeBlip = {}
onDuty = {}
prefix = '^9[^5Dead-Blips^9] ^3';

-- CODE --
Citizen.CreateThread(function()
    while true do 
        Wait(1000)
        for k, v in pairs(timeTracker) do 
            timeTracker[k] = timeTracker[k] + 1
        end 
    end 
end)

-- sendToDisc with fixed username
function sendToDisc(title, message, footer, webhookURL, color)
    local embed = {{
        ["color"] = color,
        ["title"] = "**".. title .."**",
        ["description"] = "** " .. message ..  " **",
        ["footer"] = { ["text"] = footer },
    }}
    PerformHttpRequest(webhookURL, function(err, text, headers) end,
        'POST',
        json.encode({username = "Dead-Blips", embeds = embed}),
        { ['Content-Type'] = 'application/json' })
end

-- Events
RegisterServerEvent("DeadBlips:RequestUpdate")
AddEventHandler("DeadBlips:RequestUpdate", function()
    local src = source
    for k, v in pairs(onDuty) do 
        TriggerClientEvent("DeadBlips:toggle", k, true)
    end 
end)

AddEventHandler('playerDropped', function()
    if onDuty[source] then
        onDuty[source] = nil
        permTracker[source] = nil
        activeBlip[source] = nil
    end
end)

RegisterServerEvent("DeadBlips:ToggleDuty")
AddEventHandler("DeadBlips:ToggleDuty", function()
    local src = source
    if permTracker[src] ~= nil then 
        if onDuty[src] == nil then 
            onDuty[src] = true
            timeTracker[src] = 0
            TriggerClientEvent("DeadBlips:toggle", src, true)
        else 
            onDuty[src] = nil
            local minutesActive = math.floor((timeTracker[src] or 0) / 60)
            timeTracker[src] = nil
            TriggerClientEvent("DeadBlips:toggle", src, false)
        end
    else 
        TriggerClientEvent("chatMessage", src, prefix .. "You don't have permissions to go on duty :(")
    end
end)

RegisterCommand("bliptag", function(source, args, rawCommand)
    if permTracker[source] == nil then
        TriggerClientEvent("chatMessage", source, prefix .. "You do not have permissions for blips.")
        return
    end

    if args[1] ~= nil then
        local tag = table.concat(args, " ")
        activeBlip[source] = tag
        TriggerClientEvent("DeadBlips:changeBlipName", source, tag)
        TriggerClientEvent("chatMessage", source, prefix .. "Your blip tag is now: ^5" .. tag)
    else
        activeBlip[source] = nil
        TriggerClientEvent("DeadBlips:removeBlipName", source)
        TriggerClientEvent("chatMessage", source, prefix .. "Your blip tag was ^1REMOVED")
    end
end, false)

-- Register user event
RegisterServerEvent('PoliceEMSActivity:RegisterUser')
AddEventHandler('PoliceEMSActivity:RegisterUser', function()
    local src = source
    local identifierDiscord = nil
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
    end

    if identifierDiscord then
        local roleIDs = exports.Badger_Discord_API:GetDiscordRoles(src)
        for i = 1, #roleList do
            for j = 1, #roleIDs do
                if exports.Badger_Discord_API:CheckEqual(roleList[i], roleIDs[j]) then
                    permTracker[src] = true
                    TriggerClientEvent("DeadBlips:togglePerms", src, true)
                    return
                end
            end
        end
    end
end)
