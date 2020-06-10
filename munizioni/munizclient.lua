
ESX = nil

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
end)

weaponhashes = {
    {
        weapon = "Pistola",
        whash = "453432689"
    },
    {
        weapon = "Coltello",
        whash = "-1716189206"
        
    },
    {
        weapon = "Manganello",
        whash = "1737195953"
        
    },
    {
        weapon = "Mazza Baseball",
        whash = " -1786099057"
        
    }
}

function weaponNome(hash)
    --Citizen.Trace(hash)
    for k,v in ipairs(weaponhashes) do
        -- Citizen.Trace(v.whash)
        -- local funhash = type(hash)
        -- local hashvar = type(v.whash)
        -- Citizen.Trace(funhash)  --numero
        -- Citizen.Trace(" ")
        -- Citizen.Trace(hashvar)  --stringa debug
        if tonumber(v.whash) == hash then
            weapon = v.weapon
            break
            --exports['mythic_notify']:SendAlert('success', 'Riponi l\'arma')
        elseif tonumber(v.whash) ~= hash then
            --exports['mythic_notify']:SendAlert('error', 'Errore Arma Inesistente')
            weapon = nil
        else
            exports['mythic_notify']:SendAlert('error', 'Errore Enorme')    
        end
    end
    --Citizen.Trace(weapon)
    return weapon
end



RegisterNetEvent('ricaricaammo')
AddEventHandler('ricaricaammo', function(ammo,quantity)
    local playerPed = GetPlayerPed(-1)
    local weapon

    local found,currentWeapon = GetCurrentPedWeapon(playerPed, true)    --in found c'è bool in currentweapon c'è l hash
    if found then
        for _, v in pairs(ammo.weapons) do
            if currentWeapon == v then
                weapon = v  --ritorna l'arma appartenente al campo di munizioni
                break
            end
        end

        if weapon ~= nil then
            local pedAmmo = GetAmmoInPedWeapon(playerPed, weapon)   --munizioni nella pistola
            local newAmmo = pedAmmo + quantity --munizioni nella pistola + munizioni decise da ricaricare

            ClearPedTasks(playerPed)

            --local found, maxAmmo = GetMaxAmmo(playerPed, weapon)
            local maxAmmo = 200

            if newAmmo <= maxAmmo then
                TaskReloadWeapon(playerPed)	--animazione ricarica
                local sqlWeapon = weaponNome(weapon)
                TriggerServerEvent('updateammosql', weapon, newAmmo,sqlWeapon)

                SetPedAmmo(playerPed, weapon, newAmmo)
                TriggerServerEvent('rimuovimunizionidoporicarica', ammo,quantity)
                exports['mythic_notify']:SendAlert('success', 'Hai ricaricato '.. quantity ..' munizioni')
            else
                exports['mythic_notify']:SendAlert('error', 'Munizioni massime')
            end
		else
            exports['mythic_notify']:SendAlert('error', 'Arma non trovata')
        end
    else
        exports['mythic_notify']:SendAlert('error', 'Non hai un arma selezionata')
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local currentWeapon = GetSelectedPedWeapon(GetPlayerPed(-1)) 
        DisplayAmmoThisFrame(currentWeapon)
    end
end)
