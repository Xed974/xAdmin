ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
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

local reportlist = {}
local function getInfoReport()
    local info = {}
    ESX.TriggerServerCallback('xAdmin:infoReport', function(info)
        reportlist = info
    end)
end

local open = false
local report_menu = RageUI.CreateMenu('xAdmin', ('interaction'), nil, nil, nil, nil, 255, 0, 0, 0);
local report_menu2 = RageUI.CreateSubMenu(report_menu, 'xAdmin', 'interaction')
report_menu.Display.Header = true
report_menu.Closed = function()
    open = false
end

function Report()
    if open then
        open = false
        RageUI.Visible(report_menu, false)
        return
    else
        open = true
        RageUI.Visible(report_menu, true)
        Citizen.CreateThread(function()
            while open do
                Wait(0)
                getInfoReport()
                RageUI.IsVisible(report_menu, function()
                    if #reportlist > 0 then
                        RageUI.Separator("↓ Nouveaux Signalement ↓")
                        for k,v in pairs(reportlist) do
                            RageUI.Button(k..' - Signalement de  ~r~'..v.nom..'~s~  | Id :  ~p~'..v.id..'~s~ ', nil, {RightLabel = '→→'}, true, {
                                onSelected = function()
                                    nom = v.nom
                                    nbreport = k
                                    id = v.id
                                    raison = v.args
                                end
                            }, report_menu2)
                        end
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~Aucun Signalement~s~")
                        RageUI.Separator("~1~( /report + raison )~s~")
                        RageUI.Separator("")
                    end
                end)
                RageUI.IsVisible(report_menu2, function()
                    RageUI.Separator("")
                    RageUI.Separator("Signalement numéro : ~r~"..nbreport)
                    RageUI.Separator("Auteur : ~r~"..nom.."~s~ [ ~b~"..id.."~s~ ]")
                    RageUI.Separator("Raison du signalement : ~r~"..raison)
                    RageUI.Separator("")

                    RageUI.Button('Se téléporter sur ~r~'..nom, nil, {RightLabel = '→→'}, true, {
                        onSelected = function()
                            setpsurlemec(id)
                        end
                    })
                    RageUI.Button('Téléporter ~r~'..nom..'~s~ sur moi', nil, {RightLabel = '→→'}, true, {
                        onSelected = function()
                            tplemecsurmoi(id)
                        end
                    })
                    RageUI.Button('Répondre au report', nil, {RightLabel = '→→'}, true, {
                        onSelected = function()
                            local reponse = KeyboardInput('~c~Entrez le message ici :', nil, 30)
                            local reponseReport = GetOnscreenKeyboardResult(reponse)
                            if reponseReport == "" then
                                Notification("~r~Admin\n~r~Vous n'avez pas fourni de message")
                            else
                                if reponseReport then
                                    Notification("Le message : ~b~"..reponseReport.."~s~ a été envoyer à ~r~"..GetPlayerName(GetPlayerFromServerId(id))) 
                                    TriggerServerEvent("xAdmin:message", id, "~r~Staff~s~\n"..reponseReport)
                                end
                            end
                        end
                    })
                    RageUI.Button('Fermer le report de ~r~'..nom, nil, {RightLabel = '→→'}, true, {
                        onSelected = function()
                            TriggerServerEvent('xAdmin:CloseReport', nom, raison)
                            TriggerServerEvent("xAdmin:message", id, "~r~Staff~s~\nVotre report à été fermé !")
                            reportMenu = false
                        end
                    })

                end)
            end
        end)
    end
end

RegisterCommand('reportmenu', function()
    if group == true then Report() end
end)

--- Xed#1188