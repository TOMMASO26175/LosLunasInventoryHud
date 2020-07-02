ESX = nil
ESXLoaded = false
IsLoaded = false
isInInventory = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
    ESXLoaded = true
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        IsLoaded = true
        print("LS-INVENTORYHUD:STARTED")
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        print("LS-INVENTORYHUD:CLOSING ALL INVENTORY")
        IsLoaded = false
        CloseNoSaveInv()
        local id = ESX.PlayerData.identifier
        local type = 'player'
        print(ESX.PlayerData.identifier)
        --saveInventory(ESX.PlayerData.identifier, 'player')
        TriggerServerEvent("ls_inventoryhud:server:saveinventory",id,type)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    TriggerEvent('disc-inventoryhud:refreshInventory')
    IsLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local dropSecondaryInventory = {
    type = 'drop',
    owner = 'x123y123z123'
}

RegisterNUICallback('NUIFocusOff', function(data)
    closeInventory()
end)

RegisterCommand('closeinv', function(source, args, raw)
    closeInventory()
end)

RegisterCommand('esxinv', function()
    local slots = {}
    for k,v in pairs(ESX.PlayerData.inventory) do
        print(k)
        print("VALUE")
        -- for k1,v1 in pairs(v) do
        --      print(v1)
        --  end
    end
end, false)

Citizen.CreateThread(function()
    while not IsLoaded do
        Citizen.Wait(10)
    end

    while IsLoaded do
        Citizen.Wait(10)
        if IsControlJustReleased(0, Config.OpenControl) and IsInputDisabled(0) then
            local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
            local _, floorZ = GetGroundZFor_3dCoord(x, y, z)
            dropSecondaryInventory.owner = getOwnerFromCoords(vector3(x, y, floorZ))
            openInventory(dropSecondaryInventory)
        end
        if IsControlJustReleased(0, 73) then    --when putting hands up
            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey('WEAPON_UNARMED'), true)
        end
    end
end)