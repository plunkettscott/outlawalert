--Config
local timer = 1 --in minutes - Set the time during the player is outlaw
local showOutlaw = true --Set if show outlaw act on map
local gunshotAlert = true --Set if show alert when player use gun
local carJackingAlert = true --Set if show when player do carjacking
local meleeAlert = true --Set if show when player fight in melee
local blipGunTime = 2 --in second
local blipMeleeTime = 2 --in second
local blipJackingTime = 10 -- in second
--End config

local origin = false --Don't touche it
local timing = timer * 60000 --Don't touche it
local isActive = false


GetPlayerName()
RegisterNetEvent('outlawNotify')
AddEventHandler('outlawNotify', function(alert)
    if not origin and isActive then
        Notify(alert)
    end
end)

RegisterNetEvent('outlawToggled')
AddEventHandler('outlawToggled', function()
    isActive = !isActive

    TriggerClientEvent("chat:addMessage", -1, {
        args = {
            "Outlaw alerts have been " .. (if isActive then "enabled" else "disabled" end) .. "."
        },
        color = { 5, 255, 255 }
    })
end)

function Notify(text)
    TriggerClientEvent("chat:addMessage", -1, {
        args = {
            "~r~Dispatcher",
            text
        },
        color = { 255, 255, 255 }
    })
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsSessionStarted() then
            DecorRegister("IsOutlaw",  3)
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 1)
            return
        end
    end
end)

RegisterNetEvent('thiefPlace')
AddEventHandler('thiefPlace', function(tx, ty, tz)
    if not origin and isActive then
        if carJackingAlert then
            local transT = 250
            local thiefBlip = AddBlipForCoord(tx, ty, tz)
            SetBlipSprite(thiefBlip,  10)
            SetBlipColour(thiefBlip,  1)
            SetBlipAlpha(thiefBlip,  transT)
            SetBlipAsShortRange(thiefBlip,  1)
            while transT ~= 0 do
                Wait(blipJackingTime * 4)
                transT = transT - 1
                SetBlipAlpha(thiefBlip,  transT)
                if transT == 0 then
                    SetBlipSprite(thiefBlip,  2)
                    return end
            end
            
        end
    end
end)

RegisterNetEvent('gunshotPlace')
AddEventHandler('gunshotPlace', function(gx, gy, gz)
    if not origin and isActive then
        if gunshotAlert then
            local transG = 250
            local gunshotBlip = AddBlipForCoord(gx, gy, gz)
            SetBlipSprite(gunshotBlip,  1)
            SetBlipColour(gunshotBlip,  1)
            SetBlipAlpha(gunshotBlip,  transG)
            SetBlipAsShortRange(gunshotBlip,  1)
            while transG ~= 0 do
                Wait(blipGunTime * 4)
                transG = transG - 1
                SetBlipAlpha(gunshotBlip,  transG)
                if transG == 0 then
                    SetBlipSprite(gunshotBlip,  2)
                    return end
            end
            
        end
    end
end)

RegisterNetEvent('meleePlace')
AddEventHandler('meleePlace', function(mx, my, mz)
    if not origin and isActive then
        if meleeAlert then
            local transM = 250
            local meleeBlip = AddBlipForCoord(mx, my, mz)
            SetBlipSprite(meleeBlip,  270)
            SetBlipColour(meleeBlip,  17)
            SetBlipAlpha(meleeBlip,  transG)
            SetBlipAsShortRange(meleeBlip,  1)
            while transM ~= 0 do
                Wait(blipMeleeTime * 4)
                transM = transM - 1
                SetBlipAlpha(meleeBlip,  transM)
                if transM == 0 then
                    SetBlipSprite(meleeBlip,  2)
                    return end
            end
            
        end
    end
end)

--Star color
--[[1- White
2- Black
3- Grey
4- Clear grey
5-
6-
7- Clear orange
8-
9-
10-
11-
12- Clear blue]]

Citizen.CreateThread( function()
    while true do
        Wait(0)
        if showOutlaw then
            for i = 0, 31 do
                if DecorGetInt(GetPlayerPed(i), "IsOutlaw") == 2 and GetPlayerPed(i) ~= GetPlayerPed(-1) then
                    gamerTagId = Citizen.InvokeNative(0xBFEFE3321A3F5015, GetPlayerPed(i), ".", false, false, "", 0 )
                    Citizen.InvokeNative(0xCF228E2AA03099C3, gamerTagId, 0) --Show a star
                    Citizen.InvokeNative(0x63BB75ABEDC1F6A0, gamerTagId, 7, true) --Active gamerTagId
                    Citizen.InvokeNative(0x613ED644950626AE, gamerTagId, 7, 1) --White star
                elseif DecorGetInt(GetPlayerPed(i), "IsOutlaw") == 1 then
                    Citizen.InvokeNative(0x613ED644950626AE, gamerTagId, 7, 255) -- Set Color to 255
                    Citizen.InvokeNative(0x63BB75ABEDC1F6A0, gamerTagId, 7, false) --Unactive gamerTagId
                end
            end
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        Wait(0)
        if DecorGetInt(GetPlayerPed(-1), "IsOutlaw") == 2 then
            Wait( math.ceil(timing) )
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 1)
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        if not isActive then
            Wait(0)
            local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
            local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
            local street1 = GetStreetNameFromHashKey(s1)
            local street2 = GetStreetNameFromHashKey(s2)
            if IsPedTryingToEnterALockedVehicle(GetPlayerPed(-1)) or IsPedJacking(GetPlayerPed(-1)) then
                origin = true
                DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 2)
                local male = IsPedMale(GetPlayerPed(-1))
                if male then
                    sex = "men"
                elseif not male then
                    sex = "women"
                end
                TriggerServerEvent('thiefInProgressPos', plyPos.x, plyPos.y, plyPos.z)
                local veh = GetVehiclePedIsTryingToEnter(GetPlayerPed(-1))
                local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                local vehName2 = GetLabelText(vehName)
                if s2 == 0 then
                    TriggerServerEvent('thiefInProgressS1', street1, vehName2, sex)
                elseif s2 ~= 0 then
                    TriggerServerEvent('thiefInProgress', street1, street2, vehName2, sex)
                end
                Wait(5000)
                origin = false
            end
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        if not isActive then
            Wait(0)
            local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
            local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
            local street1 = GetStreetNameFromHashKey(s1)
            local street2 = GetStreetNameFromHashKey(s2)
            if IsPedInMeleeCombat(GetPlayerPed(-1)) then 
                origin = true
                DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 2)
                local male = IsPedMale(GetPlayerPed(-1))
                if male then
                    sex = "men"
                elseif not male then
                    sex = "women"
                end
                TriggerServerEvent('meleeInProgressPos', plyPos.x, plyPos.y, plyPos.z)
                if s2 == 0 then
                    TriggerServerEvent('meleeInProgressS1', street1, sex)
                elseif s2 ~= 0 then
                    TriggerServerEvent("meleeInProgress", street1, street2, sex)
                end
                Wait(3000)
                origin = false
            end
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        if not isActive then
            Wait(0)
            local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
            local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
            local street1 = GetStreetNameFromHashKey(s1)
            local street2 = GetStreetNameFromHashKey(s2)
            if IsPedShooting(GetPlayerPed(-1)) then
                origin = true
                DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 2)
                local male = IsPedMale(GetPlayerPed(-1))
                if male then
                    sex = "men"
                elseif not male then
                    sex = "women"
                end
                TriggerServerEvent('gunshotInProgressPos', plyPos.x, plyPos.y, plyPos.z)
                if s2 == 0 then
                    TriggerServerEvent('gunshotInProgressS1', street1, sex)
                elseif s2 ~= 0 then
                    TriggerServerEvent("gunshotInProgress", street1, street2, sex)
                end
                Wait(3000)
                origin = false
            end
        end
    end
end)