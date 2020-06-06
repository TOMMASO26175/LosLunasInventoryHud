isHotKeyCoolDown = false
RegisterNUICallback('UseItem', function(data)
    if isWeapon(data.item.id) then
        currentWeaponSlot = data.slot
    end
    TriggerServerEvent('disc-inventoryhud:notifyImpendingRemoval', data.item, 1)
    TriggerServerEvent("esx:useItem", data.item.id)
    TriggerEvent('disc-inventoryhud:refreshInventory')
    data.item.msg = _U('used')
    data.item.qty = 1
    TriggerEvent('disc-inventoryhud:showItemUse', {	--messaggio del cazzo non toglie niente
        data.item
    })
end)

RegisterNUICallback('RicaricaAmmo', function(data)
    if isWeapon(data.item.id) then
        currentWeaponSlot = data.slot
    end
    TriggerServerEvent('disc-inventoryhud:ricaricaammo', data.item, 1)  --al posto di questo 1 ci deve essere in numero di munizioni notifica
    TriggerServerEvent("esx:useItem", data.item.id) --cuore del problema    messaggio in player.lua server
    Citizen.Trace(data.item.id) --nome es ammo_pistol data.item è una tabella non so quali siano le colonne 
    TriggerEvent('disc-inventoryhud:refreshInventory')
     data.item.msg = _U('used')
     data.item.qty = 1
     TriggerEvent('disc-inventoryhud:showItemUse', {	--messaggio oggetto usato
          data.item
      })
end)

RegisterNUICallback('AmmoReload',function(data)
    print(data.quantity)
    TriggerServerEvent('disc-inventoryhud:ricaricaammo', data.item, data.quantity)
    TriggerServerEvent('ammotest',data.item,data.quantity)
    TriggerServerEvent('useammo',data.item.id)
    TriggerEvent('disc-inventoryhud:refreshInventory')
    if Check then
        TriggerEvent('disc-inventoryhud:showItemUse', {data.item},data.quantity)
    end

end)


local keys = {  --1,2,3,4,5
    157, 158, 160, 164, 165
}

Citizen.CreateThread(function() --fa vedere la barra rapida e fa usare gli oggetti
    while true do
        Citizen.Wait(0)
        SetCamEffect(0)
        BlockWeaponWheelThisFrame()
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        HideHudComponentThisFrame(17)
        DisableControlAction(0, 37, true) --Disable Tab
        for k, v in pairs(keys) do
            if IsDisabledControlJustReleased(0, v) then
                UseItem(k)
            end
        end
        if IsDisabledControlJustReleased(0, 37) then
            ESX.TriggerServerCallback('disc-inventoryhud:GetItemsInSlotsDisplay', function(items)
                SendNUIMessage({
                    action = 'showActionBar',
                    items = items
                })
            end)
        end
    end
end)

function UseItem(slot)
    if isHotKeyCoolDown then
        return
    end
    Citizen.CreateThread(function()
        isHotKeyCoolDown = true
        Citizen.Wait(Config.HotKeyCooldown)
        isHotKeyCoolDown = false
    end)
    ESX.TriggerServerCallback('disc-inventoryhud:UseItemFromSlot', function(item)
        if item then
            if isWeapon(item.id) then
                currentWeaponSlot = slot
            end
            TriggerServerEvent('disc-inventoryhud:notifyImpendingRemoval', item, 1)
            TriggerServerEvent("esx:useItem", item.id)
            item.msg = _U('used')
            item.qty = 1    --deve essere uguale a quello sopra
             TriggerEvent('disc-inventoryhud:showItemUse', {
                 item,
             })
        end
    end
    , slot)
end

RegisterNetEvent('disc-inventoryhud:showItemUse')
AddEventHandler('disc-inventoryhud:showItemUse', function(items,quantity)
    local data = {}
    for k, v in pairs(items) do
        table.insert(data, {
            item = {
                label = v.label,
                itemId = v.id
            },
            qty = quantity,
            message = v.msg
        })
    end
    SendNUIMessage({
         action = 'itemUsed',
         alerts = data
    })
end)
