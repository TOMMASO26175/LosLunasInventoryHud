ESX.RegisterServerCallback('disc-inventoryhud:UseItemFromSlot', function(source, cb, slot)
    local player = ESX.GetPlayerFromId(source)
    InvType['player'].getInventory(player.identifier, function(inventory)
        if inventory[tostring(slot)] then
            print(inventory[tostring(slot)].name)
            local esxItem = player.getItem(inventory[tostring(slot)].name)
            for k,v in pairs(esxItem) do
                print(k)
                print(v)
            end
            local isammo = esxItem.name:find("^ammo") ~= nil
            if esxItem.usable and not isammo then
                cb(createDisplayItem(inventory[tostring(slot)], esxItem, slot))
                return
            elseif isammo then
                cb(false)
                return
            end
        end
        cb(nil)
    end)
end)
ESX.RegisterServerCallback('disc-inventoryhud:GetItemsInSlotsDisplay', function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    InvType['player'].getInventory(player.identifier, function(inventory)
        local slotItems = {}
        for i = 1, 5, 1 do
            local item = inventory[tostring(i)]
            if item then
                local esxItem = player.getItem(item.name)
                slotItems[i] = {
                    itemId = item.name,
                    label = esxItem.label,
                    qty = item.count,
                    slot = i
                }
            else
                slotItems[i] = nil
            end
        end
        cb(slotItems)
    end)
end)


