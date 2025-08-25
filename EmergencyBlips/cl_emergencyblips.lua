-- by: minipunch
-- for: Initially made for USA Realism RP (https://usarrp.net)
-- purpose: Provide public servants with blips for all other active emergency personnel

local ACTIVE = false
local currentBlips = {}

------------
-- events --
------------
RegisterNetEvent("eblips:toggle")
AddEventHandler("eblips:toggle", function(on)
    ACTIVE = on
    if not ACTIVE then
        RemoveAnyExistingEmergencyBlips()
    end
end)

RegisterNetEvent("eblips:updateAll")
AddEventHandler("eblips:updateAll", function(activeEmergencyPersonnel)
    if ACTIVE then
        RemoveAnyExistingEmergencyBlips()
        RefreshBlips(activeEmergencyPersonnel)
    end
end)

---------------
-- functions --
---------------
function RemoveAnyExistingEmergencyBlips()
    for i = #currentBlips, 1, -1 do
        local b = currentBlips[i]
        if b and b ~= 0 then
            RemoveBlip(b)
        end
        table.remove(currentBlips, i)
    end
end

function RefreshBlips(activeEmergencyPersonnel)
    local myServerId = GetPlayerServerId(PlayerId())
    for src, info in pairs(activeEmergencyPersonnel) do
        if src ~= myServerId and info and info.coords then
            local blip = AddBlipForCoord(info.coords.x, info.coords.y, info.coords.z)
            SetBlipSprite(blip, 1)
            SetBlipColour(blip, info.color or 1) -- fallback to white if nil
            SetBlipAsShortRange(blip, true)
            SetBlipDisplay(blip, 4)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(info.name or "Emergency Unit")
            EndTextCommandSetBlipName(blip)

            table.insert(currentBlips, blip)
        end
    end
end
