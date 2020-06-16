local serverDrops = {}
local drops = {}
local spawntime = 0
Citizen.CreateThread(function()
    while not IsLoaded do
        Citizen.Wait(10)
    end

    while IsLoaded do
        Citizen.Wait(1000)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        for k, v in pairs(serverDrops) do
            local dropCoords = getCoordsFromOwner(k)
            if GetDistanceBetweenCoords(dropCoords.x, dropCoords.y, dropCoords.z, coords.x, coords.y, coords.z, true) < 20 then
               if drops[k] then
                    drops[k].active = true
                else
                    drops[k] = {
                        name = k,
                        coords = dropCoords,
                        active = true
                    }
                end
            end
        end

        for k, v in pairs(drops) do
            if v.active then
                local x, y, z = table.unpack(v.coords)
                -- local marker = {
                --     name = v.name .. '_drop',
                --     type = 2,
                --     coords = vector3(x, y, z + 1.0),
                --     rotate = false,
                --     colour = { r = 255, b = 255, g = 255 },
                --     size = vector3(0.5, 0.5, 0.5),
                -- }
                drops[k].active = false
                --TriggerEvent('disc-base:registerMarker', marker)
                --ESX.Game.Utils.DrawText3D(marker.coords, "[~g~E~w~] Open Storage", 0.6)
                if spawntime == 0 then
                    SpawnObj(x,y,z)
                    spawntime = 1
                end
            else
                --TriggerEvent('disc-base:removeMarker', v.name .. '_drop')
                drops[k] = nil
            end
        end
    end
end)

RegisterNetEvent('disc-inventoryhud:updateDrops')
AddEventHandler('disc-inventoryhud:updateDrops', function(newDrops)
    print('Updating drops')
    serverDrops = newDrops
end)

function SpawnObj(x,y,z)
    local model   = 'prop_cs_duffel_01'
    local hash = GetHashKey(model)
    local bag = CreateObject(hash, x,y,z, true, true, true)
    PlaceObjectOnGroundProperly(bag)
end