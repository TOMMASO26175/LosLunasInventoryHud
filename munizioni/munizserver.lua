ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

Citizen.CreateThread(function()
    Citizen.Wait(0)
    for k,v in pairs(Config.Ammo) do
        ESX.RegisterUsableItem(v.name,function(source)
            TriggerClientEvent('ricaricaammo', source, v)   --passa v = oggetto ammo
        end)
    end
end)

RegisterNetEvent('rimuovimunizionidoporicarica')
AddEventHandler('rimuovimunizionidoporicarica', function(ammo)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(ammo.name,ammo.quantity)
end)