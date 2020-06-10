Citizen.CreateThread(function()
    Citizen.Wait(0)
    MySQL.Async.fetchAll('SELECT * FROM items WHERE LCASE(name) LIKE \'%weapon_%\'', {}, function(results)
        for _, v in pairs(results) do
            ESX.RegisterUsableItem(v.name, function(source)
                TriggerClientEvent('disc-inventoryhud:useWeapon', source, v.name)
            end)
        end
    end)
end)

RegisterServerEvent('updateammosql')
AddEventHandler('updateammosql', function(hash, amount, weapon)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('UPDATE ammo SET amount = @amount WHERE hash = @hash AND owner = @owner AND weapon = @weapon', {
        ['@owner'] = player.identifier,
        ['@hash'] = hash,
        ['@amount'] = amount,
        ['@weapon'] = weapon
    }, function(results)
        if results == 0 then
            MySQL.Async.execute('INSERT INTO ammo (owner, hash, amount, weapon) VALUES (@owner, @hash, @amount, @weapon)', {
                ['@owner'] = player.identifier,
                ['@hash'] = hash,
                ['@amount'] = amount,
                ['@weapon'] = weapon
            })
        end
    end)
end)

ESX.RegisterServerCallback('disc-inventoryhud:getAmmoCount', function(source, cb, hash)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM ammo WHERE owner = @owner and hash = @hash', {
        ['@owner'] = player.identifier,
        ['@hash'] = hash
    }, function(results)
        if #results == 0 then
            cb(nil)
        else
            cb(results[1].amount)
        end
    end)
end)


