ESX = nil
ItemQuantity = 1

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)


RegisterNetEvent('rimuovimunizionidoporicarica')
AddEventHandler('rimuovimunizionidoporicarica', function(ammo,quantity)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(ammo.name,quantity)
end)

RegisterNetEvent('useammo')
AddEventHandler('useammo',function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
    local count = xPlayer.getInventoryItem(itemName).count

	if count > 0 then
		ESX.UseItem(source, itemName)
	else
		xPlayer.showNotification("Errore")
	end
end)


RegisterNetEvent('ammotest')
AddEventHandler('ammotest',function(item,quantity)
    ItemQuantity = quantity
end)

Citizen.CreateThread(function()
    Citizen.Wait(0)
    for k,v in pairs(Config.Ammo) do
        ESX.RegisterUsableItem(v.name,function(source)
            TriggerClientEvent('ricaricaammo', source, v,ItemQuantity)   --passa v = oggetto ammo
        end)
    end
end)

-- RegisterNetEvent('ammotest')
-- AddEventHandler('ammotest',function(item,quantity)
--     for k, v in pairs(Config.Ammo) do
--         ESX.RegisterUsableItem(v.name,function(source)
--             TriggerClientEvent('ricaricaammo',source,v,item,quantity)
--         end)
--     end
-- end)

-- RegisterNetEvent('creaoggetti')
-- AddEventHandler('creaoggetti', function(prova)
-- Newammo  = {
--     {
--         name = 'ammo_pistol',
--         weapons = {
--             'WEAPON_PISTOL',--`
--             'WEAPON_APPISTOL',
--             'WEAPON_SNSPISTOL',
--             'WEAPON_COMBATPISTOL',
--             'WEAPON_HEAVYPISTOL',
--             'WEAPON_MACHINEPISTOL',
--             'WEAPON_MARKSMANPISTOL',
--             'WEAPON_PISTOL50',
--             'WEAPON_VINTAGEPISTOL'
--         },
--         quantity = prova
--     },
--     {
--         name = 'ammo_shotgun',
--         weapons = {
--             'WEAPON_ASSAULTSHOTGUN',
--             'WEAPON_AUTOSHOTGUN',
--             'WEAPON_BULLPUPSHOTGUN',
--             'WEAPON_DBSHOTGUN',
--             'WEAPON_HEAVYSHOTGUN',
--             'WEAPON_PUMPSHOTGUN',
--             'WEAPON_SAWNOFFSHOTGUN'
--         },
--         quantity = 1
--     },
--     {
--         name = 'ammo_smg',
--         weapons = {
--             'WEAPON_ASSAULTSMG',
--             'WEAPON_MICROSMG',
--             'WEAPON_MINISMG',
--             'WEAPON_SMG'
--         },
--         quantity = 1
--     },
--     {
--         name = 'ammo_rifle',
--         weapons = {
--             'WEAPON_ADVANCEDRIFLE',
--             'WEAPON_ASSAULTRIFLE',
--             'WEAPON_BULLPUPRIFLE',
--             'WEAPON_CARBINERIFLE',
--             'WEAPON_SPECIALCARBINE',
--             'WEAPON_COMPACTRIFLE'
--         },
--         quantity = 1
--     },
--     {
--         name = 'ammo_sniper',
--         weapons = {
--             'WEAPON_SNIPERRIFLE',
--             'WEAPON_HEAVYSNIPER',
--             'WEAPON_MARKSMANRIFLE'
--         },
--         quantity = 1
--     }
-- }
-- end)
