webhookURL = 'WEBHOOK_HERE'

displayIdentifiers = true;


function GetPlayers()
    local players = {}

    for _, i in ipairs(GetActivePlayers()) do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

RegisterCommand("warn", function(source, args, rawCommand)

	if source == 0 or IsPlayerAceAllowed(source, "Warns.Use") then
		sm = stringsplit(rawCommand, " ");
		
	if #args < 2 then
    	TriggerClientEvent('chatMessage', source, "^1Invalid Usage. ^2Proper Usage: /warn <id> <reason>")
    	return;
    end
    id = sm[2]
    if GetPlayerIdentifiers(id)[1] == nil then
    	TriggerClientEvent('chatMessage', source, "^1The specified ID is not currently online...")
    	return;
    end
	msg = ""
	local message = ""
	msg = msg .. " ^8(^6Warned By: " .. GetPlayerName(source) .. "^8) ^8[^3Person Warned: " .. GetPlayerName(id) .. "^8] ^2Warned For: ^0"
	for i = 3, #sm do
		msg = msg .. sm[i] .. " "
		message = message .. sm[i] .. " "
	end
	local target = args[1]
	if tonumber(id) ~= nil then
		
		TriggerClientEvent("Warns:CheckPermission:Client", -1, msg, false)
		TriggerClientEvent('t-notify:client:Custom', source, {
			style = 'success',
			duration = 10000,
			title = 'Shadow Warns',
			message = '**Person Warned:**\n' .. GetPlayerName(id) .. '\n**Warned For:**\n' .. message .. '\n',
			sound = true,
			custom = true
		})		

		MySQL.Async.fetchAll("INSERT INTO warning (staffmember, personwarned, message) VALUES(@source, @target, @message)",
		{["@source"] = GetPlayerName(source), ["@target"] = GetPlayerName(target), ["@message"] = message})
		
		TriggerClientEvent('chatMessage', source, "^8[^8Warns^8] ^0Warn has been submitted.")
		if not displayIdentifiers then 
			sendToDisc("NEW WARN: _[" .. tostring(id) .. "] " .. GetPlayerName(id) .. "_", 'Reason: **' .. message ..
				'**', "Warned by: [" .. source .. "] " .. GetPlayerName(source))
		else 
			
			local ids = ExtractIdentifiers(target);
			local steam = ids.steam:gsub("steam:", "");
			local steamDec = tostring(tonumber(steam,16));
			local discord = ids.discord;
			local DATE = os.date("%x %X %p");
			sendToDisc("NEW WARN", 
				'Staff Member: **<@' .. discord:gsub('discord:', '') ..
				'>**\n' ..
				'Discord Tag: **<@' .. discord:gsub('discord:', '') .. '>**\n' ..
				'Reason: **' .. message .. '**', "Date: " .. DATE .. " " )
		end 	
	end
	if tonumber(target) ~= nil then
		TriggerClientEvent('t-notify:client:Custom', target, {
			style = 'success',
			duration = 10000,
			title = 'Warns',
			message = '**Warned By:**\n' .. GetPlayerName(source) .. '\n**Warned For:**\n' .. message .. '\n',
			sound = true,
			custom = true
		})	
	end

	
else
	TriggerClientEvent('chatMessage', source, "^1Missing Permission.");
end


end)

function sendToDisc(title, message, footer)
	local embed = {}
	embed = {
		{
			["color"] = 65280, 
			["title"] = "**".. title .."**",
			["description"] = "" .. message ..  "",
			["footer"] = {
				["text"] = footer,
			},
		}
	}
	
	PerformHttpRequest(webhookURL, 
	function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
  -- END
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
function sleep (a) 
    local sec = tonumber(os.clock() + a); 
    while (os.clock() < sec) do 
    end 
end

hasPermission = {}
doesNotHavePermission = {}

RegisterNetEvent("Warns:CheckPermission")
AddEventHandler("Warns:CheckPermission", function(msg, error)
	local src = source
	if IsPlayerAceAllowed(src, "Warns.Use") then 
		TriggerClientEvent('chatMessage', src, "^9[^1Warns^9] ^8" .. msg)
	end
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
function ExtractIdentifiers(target)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

   
    for i = 0, GetNumPlayerIdentifiers(target) - 1 do
        local id = GetPlayerIdentifier(target, i)

       
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end
