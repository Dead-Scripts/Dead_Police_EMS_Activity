-- When player spawns, register them with the server
AddEventHandler("playerSpawned", function()
    TriggerServerEvent("PoliceEMSActivity:RegisterUser")
end)

-- Helper function to give weapons
local function giveWeapon(hash)
    GiveWeaponToPed(PlayerPedId(), GetHashKey(hash), 999, false, false)
end

-- Give weapons event
RegisterNetEvent("PoliceEMSActivity:GiveWeapons")
AddEventHandler("PoliceEMSActivity:GiveWeapons", function()
    giveWeapon("weapon_nightstick")
    giveWeapon("weapon_stungun")
    giveWeapon("weapon_flashlight")
    giveWeapon("weapon_combatpistol")
    GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("weapon_combatpistol"), GetHashKey("COMPONENT_AT_PI_FLSH"))

    giveWeapon("weapon_carbinerifle")
    GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("weapon_carbinerifle"), GetHashKey("COMPONENT_AT_AR_FLSH"))
    GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("weapon_carbinerifle"), GetHashKey("COMPONENT_AT_SCOPE_MEDIUM"))
    GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("weapon_carbinerifle"), GetHashKey("COMPONENT_AT_AR_SUPP"))

    giveWeapon("weapon_pumpshotgun")
    GiveWeaponComponentToPed(PlayerPedId(), GetHashKey("weapon_pumpshotgun"), GetHashKey("COMPONENT_AT_AR_FLSH"))

    SetPedArmour(PlayerPedId(), 100)
end)

-- Take weapons event
RegisterNetEvent("PoliceEMSActivity:TakeWeapons")
AddEventHandler("PoliceEMSActivity:TakeWeapons", function()
    SetPedArmour(PlayerPedId(), 0)
    RemoveAllPedWeapons(PlayerPedId(), true)
end)
