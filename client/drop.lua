local serverDrops = {}
local drops = {}
Citizen.CreateThread(function()
    while not IsLoaded do
        Citizen.Wait(10)
    end

    while IsLoaded do
        Citizen.Wait(1000)
        if table.length(serverDrops) > 0 then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            for k, _ in pairs(serverDrops) do
                local dropCoords = getCoordsFromOwner(k)
                local dist = #(vector3(dropCoords.x, dropCoords.y, dropCoords.z) - coords)
                if dist < 10.0 then
                    if drops[k] then
                        drops[k].active = true
                    else
                        drops[k] = {
                            name = k,
                            coords = dropCoords,
                            active = true,
                            spwbag = false,
                            propname = nil,
                        }
                    end
                end
            end
        end

        for k, v in pairs(drops) do
            if v.active then
                local x, y, z = table.unpack(v.coords)
                drops[k].active = false
                if not drops[k].spwbag then
                    drops[k].propname = SpawnObj(x,y,z,drops[k].name)
                    drops[k].spwbag = true
                end
                v.spwbag = true
            else
                DeleteObject(drops[k].propname)
                drops[k] = nil
            end
        end
    end
end)

RegisterNetEvent('disc-inventoryhud:updateDrops')
AddEventHandler('disc-inventoryhud:updateDrops', function(newDrops)
    print('Aggiornando Drops')
    serverDrops = newDrops
end)

function SpawnObj(x,y,z,bag)
    local model   = 'prop_cs_heist_bag_02'
    local hash = GetHashKey(model)
    bag = CreateObject(hash, x,y,z, true, true, true)
    local heading = GetEntityHeading(bag)
    SetEntityHeading(bag, heading)
    PlaceObjectOnGroundProperly(bag)
    return bag
    --SetEntityAsMissionEntity(bag)
end

function RemoveObj(obj)
    DeleteObject(obj)
end