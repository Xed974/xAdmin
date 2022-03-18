ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function Notification(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg)
	DrawNotification(false, true)
end

RegisterNetEvent("xAdmin:Notification")
AddEventHandler("xAdmin:Notification", function(msg) 
	Notification(msg) 
end)

RegisterNetEvent('setgroup')
AddEventHandler('setgroup', function()
    group = true
end)    

Citizen.CreateThread(function()
    while true do
        Citizen.Wait( 2000 )

        if NetworkIsSessionStarted() then
            TriggerServerEvent("checkadmin")
        end
    end
end)

RegisterNetEvent("xAdmin:Open/CloseReport")
AddEventHandler("xAdmin:Open/CloseReport", function(type, nomdumec, raisondumec)
    if type == 1 then
        if group == true then
            ESX.ShowNotification('Un nouveau report à été effectué !')
        end
    elseif type == 2 then
        if group == true then
            ESX.ShowNotification('Le report de ~b~'..nomdumec..'~s~ à été fermé !')
        end
    end
end)

function setpsurlemec(iddumec) 
    if iddumec then
        local PlayerPos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(iddumec)))
        SetEntityCoords(PlayerPedId(), PlayerPos.x, PlayerPos.y, PlayerPos.z)
    end
end

function tplemecsurmoi(iddugars)
    if iddugars then
        local plyPedCoords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('xAdmin:bring', iddugars, plyPedCoords, "bring")
    end
end

RegisterNetEvent('xAdmin:bring')
AddEventHandler('xAdmin:bring', function(plyPedCoords)
    plyPed = PlayerPedId()
	SetEntityCoords(plyPed, plyPedCoords)
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

--- Xed#1188