ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterCommand('pos', function()
    if group == true then
        local pos = GetEntityCoords(GetPlayerPed(-1),true)
                            
        print('Position actuel : ^4'..pos)
        ESX.ShowNotification('~b~Position affichés dans le F8 !')
    else
        ESX.ShowNotification('~r~Permissions insuffisantes !')
    end
end)

RegisterCommand('repair', function()
    if group == true then
        xVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)

        SetVehicleEngineHealth(xVeh, 1000.0)
        SetVehicleFixed(xVeh)
        SetVehicleDeformationFixed(xVeh)
    else
        ESX.ShowNotification('~r~Permissions insuffisantes !')
    end
end)

--- Xed#1188