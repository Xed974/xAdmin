ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local staffModeActive = false
local isMenuOpened = false
local playerCache = {}

RegisterNetEvent('setgroup')
AddEventHandler('setgroup', function()
    group = true
end)    

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)

        if NetworkIsSessionStarted() then
            TriggerServerEvent("checkadmin")
        end
    end
end)

RegisterNetEvent("xAdmin:cbPlayerCache")
AddEventHandler("xAdmin:cbPlayerCache", function(newPlayerCache)
    playerCache = newPlayerCache
end)

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed, false)
    TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)
    TriggerEvent('esx_status:resetStatus')

    Citizen.CreateThread(function()
        DoScreenFadeOut(800)

        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end

        RespawnPed(playerPed, {coords = coords, heading = 0.0})
        AnimpostfxStop('DeathFailOut')
        DoScreenFadeIn(800)
    end)
end)

-- GamerTags

Admin = {
    showName = false,
    gamerTags = {}
}

Citizen.CreateThread(function()
	while true do
		if Admin.showName then
			for k, v in ipairs(ESX.Game.GetPlayers()) do
				local otherPed = GetPlayerPed(v)

				if otherPed ~= plyPed then
					if #(GetEntityCoords(plyPed, false) - GetEntityCoords(otherPed, false)) < 5000.0 then
						Admin.gamerTags[v] = CreateFakeMpGamerTag(otherPed, ('[%s] %s'):format(GetPlayerServerId(v), GetPlayerName(v)), false, false, '', 0)
					else
						RemoveMpGamerTag(Admin.gamerTags[v])
						Admin.gamerTags[v] = nil
					end
				end
			end
		end

		Citizen.Wait(100)
	end
end)

-- NoClip

function DrawPlayerInfo(target)
	drawTarget = target
	drawInfo = true
end
function StopDrawPlayerInfo()
	drawInfo = false
	drawTarget = 0
end
Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)
		if drawInfo then
			local text = {}
			local targetPed = GetPlayerPed(drawTarget)
			table.insert(text,"E pour stop spectate")
			
			for i,theText in pairs(text) do
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString(theText)
				EndTextCommandDisplayText(0.3, 0.7+(i/30))
			end
			if IsControlJustPressed(0,103) then
				local targetPed = PlayerPedId()
				local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
	
				RequestCollisionAtCoord(targetx,targety,targetz)
				NetworkSetInSpectatorMode(false, targetPed)
				StopDrawPlayerInfo()
			end
		end
	end
end)
function SpectatePlayer(targetPed,target,name)
    local playerPed = PlayerPedId() -- yourself
	enable = true
	if targetPed == playerPed then enable = false end

    if(enable)then

        local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

        RequestCollisionAtCoord(targetx,targety,targetz)
        NetworkSetInSpectatorMode(true, targetPed)
		DrawPlayerInfo(target)
        ESX.ShowNotification('~g~Mode spectateur en cours')
    else

        local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

        RequestCollisionAtCoord(targetx,targety,targetz)
        NetworkSetInSpectatorMode(false, targetPed)
		StopDrawPlayerInfo()
        ESX.ShowNotification('~b~Mode spectateur arrêtée')
    end
end
function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end
function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end
function setupScaleform(scaleform)

    local scaleform = RequestScaleformMovie(scaleform)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(1)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    Button(GetControlInstructionalButton(2, config.controls.goUp, true))
    ButtonMessage("Monter")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    Button(GetControlInstructionalButton(2, config.controls.goDown, true))
    ButtonMessage("Descendre")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(1, config.controls.turnRight, true))
    Button(GetControlInstructionalButton(1, config.controls.turnLeft, true))
    ButtonMessage("Tourner Gauche/Droite")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(1, config.controls.goBackward, true))
    Button(GetControlInstructionalButton(1, config.controls.goForward, true))
    ButtonMessage("Aller Devant/Derrière")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, config.controls.changeSpeed, true))
    ButtonMessage("Changer Vitesse ("..config.speeds[index].label..")")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(config.bgR)
    PushScaleformMovieFunctionParameterInt(config.bgG)
    PushScaleformMovieFunctionParameterInt(config.bgB)
    PushScaleformMovieFunctionParameterInt(config.bgA)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

config = {
    controls = {
        -- [[Controls, list can be found here : https://docs.fivem.net/game-references/controls/]]
        openKey = 288, -- [[F2]]
        goUp = 85, -- [[Q]]
        goDown = 48, -- [[Z]]
        turnLeft = 34, -- [[A]]
        turnRight = 35, -- [[D]]
        goForward = 32,  -- [[W]]
        goBackward = 33, -- [[S]]
        changeSpeed = 21, -- [[L-Shift]]
    },
    speeds = {
        -- [[If you wish to change the speeds or labels there are associated with then here is the place.]]
        { label = "Très Lent", speed = 0},
        { label = "Lent", speed = 0.5},
        { label = "Normal", speed = 2},
        { label = "Rapide", speed = 4},
        { label = "Très Rapide", speed = 6},
        { label = "Extremement Rapide", speed = 10},
        { label = "Extremement Rapide v2.0", speed = 20},
        { label = "Vitesse Max", speed = 25}
    },
    offsets = {
        y = 0.5, -- [[How much distance you move forward and backward while the respective button is pressed]]
        z = 0.2, -- [[How much distance you move upward and downward while the respective button is pressed]]
        h = 3, -- [[How much you rotate. ]]
    },
    -- [[Background colour of the buttons. (It may be the standard black on first opening, just re-opening.)]]
    bgR = 0, -- [[Red]]
    bgG = 0, -- [[Green]]
    bgB = 0, -- [[Blue]]
    bgA = 80, -- [[Alpha]]
}

noclipActive = false -- [[Wouldn't touch this.]]
index = 1 -- [[Used to determine the index of the speeds table.]]

Citizen.CreateThread(function()

    buttons = setupScaleform("instructional_buttons")
    currentSpeed = config.speeds[index].speed

    while true do
        Citizen.Wait(1)

        if noclipActive then
            SetEntityVisible(noclipEntity, false, false)
            DrawScaleformMovieFullscreen(buttons)
            setupScaleform("instructional_buttons")

            local yoff = 0.0
            local zoff = 0.0

            if IsControlJustPressed(1, config.controls.changeSpeed) then
                if index ~= 8 then
                    index = index+1
                    currentSpeed = config.speeds[index].speed
                else
                    currentSpeed = config.speeds[1].speed
                    index = 1
                end
            end

			if IsControlPressed(0, config.controls.goForward) then
                yoff = config.offsets.y
			end
			
            if IsControlPressed(0, config.controls.goBackward) then
                yoff = -config.offsets.y
			end
			
            if IsControlPressed(0, config.controls.turnLeft) then
                SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity)+config.offsets.h)
			end
			
            if IsControlPressed(0, config.controls.turnRight) then
                SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity)-config.offsets.h)
			end
			
            if IsControlPressed(0, config.controls.goUp) then
                zoff = config.offsets.z
			end
			
            if IsControlPressed(0, config.controls.goDown) then
                zoff = -config.offsets.z
			end
			
            local newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (currentSpeed + 0.3), zoff * (currentSpeed + 0.3))
            local heading = GetEntityHeading(noclipEntity)
            SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
            SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
            SetEntityHeading(noclipEntity, heading)
            SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, noclipActive, noclipActive, noclipActive)
        end
    end
end)

--

function tp_marqueur()
    local playerPed = GetPlayerPed(-1)
    local WaypointHandle = GetFirstBlipInfoId(8)

    if DoesBlipExist(WaypointHandle) then
        local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
        SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, -199.5, false, false, false, true)
        ESX.ShowNotification('~g~TP sur le marqueur effectué avec succès !')              
    else
        ESX.ShowNotification('~r~Aucun marqueur sur la map !')                 
    end
end

--

local admin_menu = RageUI.CreateMenu("xAdmin", ("interaction"), nil, nil, nil, nil, 255, 0, 0, 0);
local admin_menu_player = RageUI.CreateSubMenu(admin_menu, "xAdmin", "interaction")
local admin_menu_player2 = RageUI.CreateSubMenu(admin_menu, "xAdmin", "interaction")
local admin_menu_player3 = RageUI.CreateSubMenu(admin_menu, "xAdmin", "interaction")
local admin_menu_player4 = RageUI.CreateSubMenu(admin_menu, "xAdmin", "interaction")
local admin_menu_player5 = RageUI.CreateSubMenu(admin_menu, "xAdmin", "interaction")
admin_menu.Closed = function()
    isMenuOpened = false
end
local Customs = {
    List1 = 1,
}

local function openAdminMenu()
    if (isMenuOpened) then
        return
    end
    local selectedPlayer = nil
    isMenuOpened = true
    RageUI.Visible(admin_menu, true)
    CreateThread(function()
        while (isMenuOpened) do
            Wait(0)

            RageUI.IsVisible(admin_menu, function()
                RageUI.Checkbox("Activer/Désactiver le mode staff", nil, staffModeActive, {}, {
                    onChecked = function()
                        staffModeActive = true
                        TriggerServerEvent("xAdmin:setStaffMode", true)
                    end,

                    onUnChecked = function()
                        staffModeActive = false
                        TriggerServerEvent("xAdmin:setStaffMode", false)
                    end
                })

                if (staffModeActive) then
                    RageUI.Line2()
                    RageUI.Button('Listes joueurs', nil, { RightLabel = "→" }, true, {
                        onSelected = function()
                        end
                    },admin_menu_player)
                    RageUI.Button('Gestion joueurs', nil, { RightLabel = "→" }, true, {
                        onSelected = function()
                        end
                    }, admin_menu_player3)
                    RageUI.Button('Gestion véhicule', nil, { RightLabel = "→" }, true, {
                        onSelected = function()
                        end
                    }, admin_menu_player5)
                    RageUI.Button('Options Personnel', nil, { RightLabel = "→" }, true, {
                        onSelected = function()
                        end
                    }, admin_menu_player4)
                    RageUI.Button('Menu Report', nil, { RightLabel = "→" }, true, {
                        onSelected = function()
                            ExecuteCommand('reportmenu')
                        end
                    })
                    RageUI.Line2()

                end
            end)

            RageUI.IsVisible(admin_menu_player, function()
                for k,v in pairs(playerCache) do
                    RageUI.Button("[~b~"..v.id.."~s~] "..v.name, nil, { RightLabel = "→" }, true, {
                        onSelected = function()
                            selectedPlayer = k
                        end
                    }, admin_menu_player2)
                end
            end)

            RageUI.IsVisible(admin_menu_player2, function()
                if (selectedPlayer ~= nil) then
                    if (not (playerCache[selectedPlayer])) then
                        RageUI.GoBack()
                    else
                        local player = playerCache[selectedPlayer]
                        RageUI.Separator("Sélection: ~b~"..player.name)
                        RageUI.Separator("↓ ~r~Informations~s~ ↓")
                        RageUI.Button("Job: ~b~"..player.job.label.."~s~ (~b~"..player.job.grade_label.."~s~)", nil, {}, true, {})
                        RageUI.Button("Job2: ~b~"..player.job2.label.."~s~ (~b~"..player.job2.grade_label.."~s~)", nil, {}, true, {})
                        RageUI.Separator("↓ ~r~Actions~s~ ↓")
                        RageUI.Button("Kick", nil, { RightLabel = "~r~Éxecuter ~s~→"}, true, {
                            onSelected = function()
                                TriggerServerEvent("xAdmin:kickPlayer", player.id, "Vous avez été kick par un membre du staff.")
                            end
                        })
                    end
                end
            end)
            RageUI.IsVisible(admin_menu_player3, function()
                RageUI.Button('Give de l\'argent à un joueur', nil, { RightLabel = "→" }, true, {
                    onSelected = function()
                        id = KeyboardInput("ID du joueur", "", 10)
                        types = KeyboardInput("bank or cash ?", "", 10)
                        quantite = KeyboardInput("Quantité à give", "", 10)

                        if id ~= nil and type ~= nil and quantite ~= nil then
                            TriggerServerEvent("xAdmin:givemoney", id, types, quantite)
                        end
                    end
                })
                RageUI.Button('Give un item à un joueurs', nil, { RightLabel = "→" }, true, {
                    onSelected = function()
                        id = KeyboardInput("ID du joueur", "", 10)
                        item = KeyboardInput("Nom de l'item", "", 10)
                        quantite = KeyboardInput("Quantité à give", "", 10)

                        if id ~= nil and item ~= nil and quantite ~= nil then
                            TriggerServerEvent("xAdmin:giveitem", id, item, quantite)
                        end
                    end
                })
                if Config.Settings.Armes == true then
                    RageUI.Button('Give une arme à un joueurs', nil, { RightLabel = "→" }, true, {
                        onSelected = function()
                            id = KeyboardInput("ID du joueur", "", 10)
                            arme = KeyboardInput("Nom de l'arme", "", 20)
                            quantite = KeyboardInput("Quantité de balles", "", 10)

                            if id ~= nil and arme ~= nil and quantite ~= nil then
                                TriggerServerEvent("xAdmin:givearme", id, arme, quantite)
                            end
                        end
                    })
                end
                RageUI.Line()
                RageUI.Button('Setjob un joueur', nil, { RightLabel = "→" }, true, {
                    onSelected = function()
                        id = KeyboardInput("ID du joueur", "", 10)
                        job = KeyboardInput("Job", "", 10)
                        grade = KeyboardInput("Grades", "", 10)

                        if id ~= nil and job ~= nil and grade ~= nil then
                            TriggerServerEvent("xAdmin:setjob", id, job, grade)
                        end
                    end
                })
                RageUI.Button('Heal un joueur', nil, { RightLabel = "→" }, true, {
                    onSelected = function()
                        id = KeyboardInput("ID du joueur", "", 10)

                        if id ~= nil then
                            SetEntityHealth(PlayerPedId(id), 200)
                        end
                    end
                })
                RageUI.Button('Revive un joueur', nil, { RightLabel = "→" }, true, {
                    onSelected = function()
                        id = KeyboardInput("ID du joueur", "", 10)

                        if id ~= nil then
                            TriggerServerEvent('xAdmin:revive', id)
                        end
                    end
                })
                RageUI.List("Freeze/DeFreeze un joueur", {"Freeze", "DeFreeze"}, Customs.List1, nil, {Preview}, true, {
                    onListChange = function(i, Item)
                      Customs.List1 = i;
                    end,

                    onSelected = function()
                        if Customs.List1 == 1 then
                            id = KeyboardInput("ID du joueur", "", 10)

                            if id ~= nil then
                                FreezeEntityPosition(PlayerPedId(id), true)
                            end
                        end
            
                        if Customs.List1 == 2 then
                            id = KeyboardInput("ID du joueur", "", 10)

                            if id ~= nil then
                                FreezeEntityPosition(PlayerPedId(id), false)
                            end
                        end
                    end, 
                })
            end)
            RageUI.IsVisible(admin_menu_player4, function()
                RageUI.Button('NoClip', nil, { RightLabel = "→" }, true, {
                    onSelected = function()
                        noclipActive = not noclipActive

                        if IsPedInAnyVehicle(PlayerPedId(), false) then
                            noclipEntity = GetVehiclePedIsIn(PlayerPedId(), false)
                        else
                            noclipEntity = PlayerPedId()
                        end
    
                        SetEntityCollision(noclipEntity, not noclipActive, not noclipActive)
                        FreezeEntityPosition(noclipEntity, noclipActive)
                        SetEntityInvincible(noclipEntity, noclipActive)
                        SetVehicleRadioEnabled(noclipEntity, not noclipActive)
                        SetEntityVisible(noclipEntity, true, true)
                    end
                })
                RageUI.Button('GamerTags', nil, { RightLabel = "→" }, true, {
                    onSelected = function()
                        Admin.showName = not Admin.showName

                        if not showname then
                            for k, v in pairs(Admin.gamerTags) do
                                RemoveMpGamerTag(v)
                                Admin.gamerTags[k] = nil
                            end
                        end  
                    end
                })
                RageUI.Button('TP sur marqueur', nil, { RightLabel = "→" }, true, {
                    onSelected = function()
                        tp_marqueur()
                    end
                })
                RageUI.Button('Coordonnées', nil, { RightLabel = "→" }, true, {
                    onSelected = function()
                        local pos = GetEntityCoords(GetPlayerPed(-1),true)
                        
                        print('Position actuel : ^4'..pos)
                        ESX.ShowNotification('~b~Position affichés dans le F8 !')
                    end
                })
            end)
            RageUI.IsVisible(admin_menu_player5, function()
                RageUI.Button('Spawn un véhicule', nil, { RightLabel = "→" }, true, {
                    onSelected = function()
                        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                        model = KeyboardInput("Modèle", "", 10)
                        model2 = GetHashKey(model)
                        RequestModel(model2) do Citizen.Wait(10) end
                        if model ~= nil then
                            local vehicle = CreateVehicle(model2, plyCoords.x, plyCoords.y, plyCoords.z, plyCoords.h, true, false)
                            ESX.ShowNotification('~g~Véhicule spawn avec succès !')
                        else
                            ESX.ShowNotification('~r~Modèle incorrect !')
                        end
                    end
                })
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    RageUI.Button('Delete un véhicule', nil, { RightLabel = "→" }, true, {
                        onSelected = function()
                            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                            local model = GetEntityModel(vehicle)
                            local nom = GetDisplayNameFromVehicleModel(model)
    
                            if nom ~= nil then
                                ESX.Game.DeleteVehicle(vehicle)
                                ESX.ShowNotification('~g~Véhicule delete avec succès !')
                            end
                        end
                    })
                    RageUI.Button('Réparer le véhicule', nil, { RightLabel = "→" }, true, {
                        onSelected = function()
                            xVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)

                            SetVehicleEngineHealth(xVeh, 1000.0)
                            SetVehicleFixed(xVeh)
                            SetVehicleDeformationFixed(xVeh)
                        end
                    })
                    RageUI.Button('Changer la plaque du véhicule', nil, { RightLabel = "→" }, true, {
                        onSelected = function()
                            local plaqueVehicule = KeyboardInput("Plaque", "", 8)
                            SetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false) , plaqueVehicule)
                            ESX.ShowNotification("Plaque changée en : ~b~"..plaqueVehicule)
                        end
                    })
                else
                    RageUI.ButtonWithStyle("Delete un véhicule", nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered, s, Selected)                                                                                                                   
                        if Selected then
                            ESX.ShowNotification('~r~Impossible d\'effectuer cette action !')
                        end
                    end) 
                    RageUI.ButtonWithStyle("Réparer le véhicule", nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered, s, Selected)                                                                                                                   
                        if Selected then
                            ESX.ShowNotification('~r~Impossible d\'effectuer cette action !')
                        end
                    end)
                    RageUI.ButtonWithStyle("Changer la plaque du véhicule", nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered, s, Selected)                                                                                                                   
                        if Selected then
                            ESX.ShowNotification('~r~Impossible d\'effectuer cette action !')
                        end
                    end)
                end
            end)
        end
    end)
end

SetTimeout(100, function()
    TriggerServerEvent("xAdmin:ready")
end)

Keys.Register(Config.Touches.Open, 'admin', 'Ouvrir le menu admin', function()
    if group == true then openAdminMenu() end
end)

--- Bind

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(1, Config.Touches.TP) then
            if staffModeActive == true then
                tp_marqueur()
            end
        end
    end
end)

--- Xed#1188
