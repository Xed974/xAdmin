ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local activeStaff = {}
local activePlayers = {}

local admins = {
    'steam:',
}

function isAdmin(player)
    local allowed = false
    for i,id in ipairs(admins) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end

RegisterServerEvent('checkadmin')
AddEventHandler('checkadmin', function()
	local id = source
	if isAdmin(id) then
		TriggerClientEvent("setgroup", source)
	end
end)

local function isStaffModeActive(_src)
    for k,v in pairs(activeStaff) do
        if (_src == v) then
            return true
        end
    end
    return false
end

local function setAsActiveStaff(_src)
    if (not (isStaffModeActive(_src))) then
        print("^3[xAdmin] ^7" .. GetPlayerName(_src) .. " est en mode staff")
        table.insert(activeStaff, _src)
    end
end

local function removeFromActiveStaff(_src)
    if (isStaffModeActive(_src)) then
        for k,v in pairs(activeStaff) do
            if (_src == v) then
                print("^3[xAdmin] ^7" .. GetPlayerName(_src) .. " n'est plus en mode staf")
                table.remove(activeStaff, k)
                break
            end
        end
    end
end

local function isPlayerActive(_src)
    for k,v in pairs(activePlayers) do
        if (_src == v) then
            return true
        end
    end
    return false
end

local function setAsActivePlayer(_src)
    if (not (isPlayerActive(_src))) then
        print("^1[xAdmin] ^7Player ".._src.." s'est connecté(e).")
        table.insert(activePlayers, _src)
    end
end

local function removeFromActivePlayer(_src)
    if (isPlayerActive(_src)) then
        for k,v in pairs(activePlayers) do
            if (_src == v) then
                table.remove(activePlayers, k)
                print("^1[xAdmin] ^7Player ".._src.." s'est déconnecté(e).")
                break
            end
        end
    end
end

local function clearESXPlayersCache(_src)
    TriggerClientEvent("xAdmin:cbPlayerCache", _src, nil)
end

local function sendESXPlayersCache(_src)
    local players = ESX.GetPlayers()
    local playersCache = {}
    for k,v in pairs(players) do
        local player = ESX.GetPlayerFromId(v)
        if (isPlayerActive(v)) then
            local playerCache = {
                id = v,
                identifier = player.identifier,
                name = player.name,
                job = player.job,
                job2 = player.job2,
            }
            table.insert(playersCache, playerCache)
        end
    end
    TriggerClientEvent("xAdmin:cbPlayerCache", _src, playersCache)
end

local function updatePlayersCacheForActiveStaff()
    for k,v in pairs(activeStaff) do
        sendESXPlayersCache(v)
    end
end

AddEventHandler("playerDropped", function(reason)
    local _src = source
    removeFromActiveStaff(_src)
    removeFromActivePlayer(_src)
    updatePlayersCacheForActiveStaff()
end)

RegisterNetEvent("xAdmin:ready")
AddEventHandler("xAdmin:ready", function()
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    while (xPlayer == nil) do
        Wait(1000)
        xPlayer = ESX.GetPlayerFromId(_src)
    end
	setAsActivePlayer(_src)
    updatePlayersCacheForActiveStaff()
end)

RegisterNetEvent("xAdmin:setStaffMode")
AddEventHandler("xAdmin:setStaffMode", function(state)
    local _src = source
    if (state) then
        setAsActiveStaff(_src)
        sendESXPlayersCache(_src)
    else
        removeFromActiveStaff(_src)
    end
end)

-- Actions

RegisterNetEvent("xAdmin:kickPlayer")
AddEventHandler("xAdmin:kickPlayer", function(playerId, reason)
    local _src = source
    if (isStaffModeActive(_src)) then
        print("^5[xAdmin] ^7Player "..playerId.." a été expulsé pour "..reason)
        DropPlayer(playerId, reason)
    end
end)

RegisterNetEvent("xAdmin:giveitem")
AddEventHandler("xAdmin:giveitem", function(id, item, quantite)
    local xPlayer = ESX.GetPlayerFromId(id)
    local staff = source
    
    if isAdmin(staff) then
        xPlayer.addInventoryItem(item, tonumber(quantite))
        TriggerClientEvent('esx:showNotification', source, '~g~Give effectué avec succès !')
    end
end)
RegisterNetEvent("xAdmin:givearme")
AddEventHandler("xAdmin:givearme", function(id, arme, quantite)
    local xPlayer = ESX.GetPlayerFromId(id)
    local staff = source
    
    if isAdmin(staff) then
        xPlayer.addWeapon(arme, tonumber(quantite))
        TriggerClientEvent('esx:showNotification', source, '~g~Give effectué avec succès !')
    end
end)
RegisterNetEvent("xAdmin:givemoney")
AddEventHandler("xAdmin:givemoney", function(id, types, quantite)
    local xPlayer = ESX.GetPlayerFromId(id)
    local staff = source
    
    if isAdmin(staff) then
        if types == 'bank' then
            xPlayer.addAccountMoney(types, tonumber(quantite))
            TriggerClientEvent('esx:showNotification', source, '~g~Give effectué avec succès !')
        else
            xPlayer.addMoney(tonumber(quantite))
            TriggerClientEvent('esx:showNotification', source, '~g~Give effectué avec succès !')
        end
    end
end)
RegisterNetEvent("xAdmin:setjob")
AddEventHandler("xAdmin:setjob", function(id, job, grade)
    local xPlayer = ESX.GetPlayerFromId(id)
    local staff = source
    
    if isAdmin(staff) then
        xPlayer.setJob(job, tonumber(grade))
        TriggerClientEvent('esx:showNotification', source, '~g~Setjob effectué avec succès !')
    end
end)

-- Revive

RegisterNetEvent('xAdmin:revive')
AddEventHandler('xAdmin:revive', function(id)
    local staff = source

    if isAdmin(staff) then
        if id ~= nil then
            if GetPlayerName(tonumber(id)) ~= nil then
                TriggerClientEvent('esx_ambulancejob:revive', tonumber(id))
            end
        else
            TriggerClientEvent('esx_ambulancejob:revive', source)
        end
    end
end)

-- Report

local reportTable = {}

RegisterCommand('report', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
    local NomDuMec = xPlayer.getName()
    local idDuMec = source
    local Raison = table.concat(args, " ")
    if #Raison <= 1 then
        TriggerClientEvent("esx:showNotification", source, "~r~Veuillez rentrer une raison valable.")
    elseif #Raison >= 20 then
        TriggerClientEvent("esx:showNotification", source, "~r~Veuillez rentrer une raison moins longue.")
    else
        TriggerClientEvent("esx:showNotification", source, "~g~Votre report à bien été envoyer à l'équipe de modération.")
        TriggerClientEvent("xAdmin:Open/CloseReport", -1, 1)
        table.insert(reportTable, {
            id = idDuMec,
            nom = NomDuMec,
            args = Raison,
        })
    end
end, false)

RegisterServerEvent("xAdmin:CloseReport")
AddEventHandler("xAdmin:CloseReport", function(nomMec, raisonMec)
    TriggerClientEvent("xAdmin:Open/CloseReport", -1, 2, nomMec, raisonMec)
    table.remove(reportTable, id, nom, args)
end)

ESX.RegisterServerCallback('xAdmin:infoReport', function(source, cb)
    cb(reportTable)
end)

RegisterServerEvent("xAdmin:bring")
AddEventHandler("xAdmin:bring",function(IdDuMec, plyPedCoords, lequel)
    local xPlayer = ESX.GetPlayerFromId(source)
    local staff = source

    if isAdmin(staff) then
        if lequel == "bring" then
            TriggerClientEvent("xAdmin:bring", IdDuMec, plyPedCoords)
        else
            TriggerClientEvent("xAdmin:bring", plyPedCoords, IdDuMec)
        end
    end

end)

RegisterServerEvent("xAdmin:message")
AddEventHandler("xAdmin:message", function(onlyjoueurs, message)
    TriggerClientEvent("xAdmin:Notification", onlyjoueurs, message)
end)

-- Warn

local resultServer = {}

RegisterNetEvent('xAdmin:warnplayer')
AddEventHandler('xAdmin:warnplayer', function(name, raison)
    local source = source

    MySQL.Async.execute("INSERT INTO warn (name,raison) VALUES (@a,@b)", {
        ["a"] = name,
        ["b"] = raison,
    }, function()
        TriggerClientEvent('esx:showNotification', source, '~r~'..name..'~s~ à reçu un warn !')
    end)
end)

RegisterNetEvent('xAdmin:checkwarn')
AddEventHandler('xAdmin:checkwarn', function()
    local source = source

    MySQL.Async.fetchAll("SELECT * FROM warn", {}, function(result)
        if (result) then
            resultServer = result
            TriggerClientEvent('xAdmin:getwarn', source, resultServer)
        end
    end)
end)

RegisterNetEvent('xAdmin:deletewarn')
AddEventHandler('xAdmin:deletewarn', function(name, raison)
    local source = source

    MySQL.Async.execute("DELETE FROM warn WHERE name=@a AND raison=@b", {
        ["a"] = name,
        ["b"] = raison,
    }, function()
        TriggerClientEvent('esx:showNotification', source, '~g~Warn supprimer avec succès !')
    end)
end)

--- Xed#1188
