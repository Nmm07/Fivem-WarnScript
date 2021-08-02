RegisterNetEvent("Warns:CheckPermission:Client")
AddEventHandler("Warns:CheckPermission:Client", function(msg, error)
	TriggerServerEvent("Warns:CheckPermission", msg, false)
end)

function ShowInfo(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName(text)
	DrawNotification(false, false)
end

