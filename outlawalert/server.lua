RegisterServerEvent('thiefInProgress')
AddEventHandler('thiefInProgress', function(street1, street2, veh, vehplate)
	if veh == "NULL" then
		TriggerClientEvent("outlawNotify", -1, "A vehicle was stolen between "..street1.." and "..street2)
	else
		TriggerClientEvent("outlawNotify", -1, "A "..veh.." was stolen between "..street1.." and "..street2)
	end
end)

RegisterServerEvent('thiefInProgressS1')
AddEventHandler('thiefInProgressS1', function(street1, veh, vehplate)
	if veh == "NULL" then
		TriggerClientEvent("outlawNotify", -1, "A vehicle was stolen at "..street1)
	else
		TriggerClientEvent("outlawNotify", -1, "A "..veh.." was stolen at "..street1)
	end
end)

RegisterServerEvent('meleeInProgress')
AddEventHandler('meleeInProgress', function(street1, street2, sex)
	TriggerClientEvent("outlawNotify", -1, "Fight initiated between "..street1.." and "..street2)
end)

RegisterServerEvent('meleeInProgressS1')
AddEventHandler('meleeInProgressS1', function(street1, sex)
	TriggerClientEvent("outlawNotify", -1, "Fight initiated by a "..sex.." at "..street1)
end)


RegisterServerEvent('gunshotInProgress')
AddEventHandler('gunshotInProgress', function(street1, street2, sex)
	TriggerClientEvent("outlawNotify", -1, "A firearm was discharged between "..street1.." and "..street2)
end)

RegisterServerEvent('gunshotInProgressS1')
AddEventHandler('gunshotInProgressS1', function(street1, sex)
	TriggerClientEvent("outlawNotify", -1, "A firearm was discharged at "..street1)
end)

RegisterServerEvent('thiefInProgressPos')
AddEventHandler('thiefInProgressPos', function(tx, ty, tz)
	TriggerClientEvent('thiefPlace', -1, tx, ty, tz)
end)

RegisterServerEvent('gunshotInProgressPos')
AddEventHandler('gunshotInProgressPos', function(gx, gy, gz)
	TriggerClientEvent('gunshotPlace', -1, gx, gy, gz)
end)

RegisterServerEvent('meleeInProgressPos')
AddEventHandler('meleeInProgressPos', function(mx, my, mz)
	TriggerClientEvent('meleePlace', -1, mx, my, mz)
end)

RegisterCommand("outlaw", function(source, args, rawCommand)
    -- If the source is > 0, then that means it must be a player.
    if (source > 0) then
		TriggerClientEvent('outlawToggled', source)
    end
end, false)