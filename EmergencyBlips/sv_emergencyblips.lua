-- by: minipunch
-- for: Initially made for USA Realism RP (https://usarrp.net)
-- purpose: Provide public servants with blips for all other active emergency personnel

local ACTIVE_EMERGENCY_PERSONNEL = {}
local CLIENT_UPDATE_INTERVAL_SECONDS = Config and Config.CLIENT_UPDATE_INTERVAL_SECONDS or 5

--[[ Example:
person = {
    color = 3,
    name = "Taylor Weitman"
}
]]

RegisterServerEvent("eblips:add")
AddEventHandler("eblips:add", function(person)
    local src = source
    if not person then return end

    ACTIVE_EMERGENCY_PERSONNEL[src] = {
        src = src,
        color = person.color or 1,
        name  = person.name or ("Unit " .. src)
    }

    TriggerClientEvent("eblips:toggle", src, true)
end)

RegisterServerEvent("eblips:remove")
AddEventHandler("eblips:remove", function()
    local src = source
    ACTIVE_EMERGENCY_PERSONNEL[src] = nil
    TriggerClientEvent("eblips:toggle", src, false)
end)

-- Clean up when a player drops
AddEventHandler("playerDropped", function()
    local src = source
    if ACTIVE_EMERGENCY_PERSONNEL[src] then
        ACTIVE_EMERGENCY_PERSONNEL[src] = nil
    end
end)

Citizen.CreateThread(function()
    local lastUpdateTime = os.time()
    while true do
        if os.difftime(os.time(), lastUpdateTime) >= CLIENT_UPDATE_INTERVAL_SECONDS then
            for id, info in pairs(ACTIVE_EMERGENCY_PERSONNEL) do
                if GetPlayerPed(id) ~= 0 then
                    ACTIVE_EMERGENCY_PERSONNEL[id].coords = GetEntityCoords(GetPlayerPed(id))
                    TriggerClientEvent("eblips:updateAll", id, ACTIVE_EMERGENCY_PERSONNEL)
                end
            end
            lastUpdateTime = os.time()
        end
        Wait(500)
    end
end)
