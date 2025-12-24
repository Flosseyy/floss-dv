local DISCORD_WEBHOOK = 'your_webhook_here'

local CLEANUP_INTERVAL = 30 * 60 * 1000

local WARNINGS = {30, 15}

local function sendChatMessage(message)
    TriggerClientEvent('chat:addMessage', -1, {
        color = {255, 50, 50},
        multiline = true,
        args = {'SERVER', message}
    })
end

local function sendDiscordLog(title, description, color)
    if DISCORD_WEBHOOK == '' then return end
    
    local embed = {
        {
            ['title'] = title,
            ['description'] = description,
            ['color'] = color,
            ['timestamp'] = os.date('!%Y-%m-%dT%H:%M:%S'),
            ['footer'] = {
                ['text'] = 'Vehicle Cleanup'
            }
        }
    }
    
    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({
        username = 'Vehicle Cleanup',
        embeds = embed
    }), {['Content-Type'] = 'application/json'})
end

local function isVehicleOccupied(vehicle)
    for i = -1, 7 do
        local ped = GetPedInVehicleSeat(vehicle, i)
        if ped ~= 0 then
            return true
        end
    end
    
    return false
end

local function cleanupVehicles(initiator)
    print('[Vehicle Cleanup] Starting cleanup...')
    local vehicles = GetAllVehicles()
    print(('[Vehicle Cleanup] Found %d vehicles'):format(#vehicles))
    local deletedCount = 0
    local skippedCount = 0

    for _, vehicle in ipairs(vehicles) do
        if DoesEntityExist(vehicle) then
            if isVehicleOccupied(vehicle) then
                skippedCount = skippedCount + 1
            else
                DeleteEntity(vehicle)
                deletedCount = deletedCount + 1
            end
        end
    end

    local message = ('Vehicle cleanup complete! %d vehicles deleted.'):format(deletedCount)
    sendChatMessage(message)

    print(('[Vehicle Cleanup] Deleted %d vehicles'):format(deletedCount))
    
    local discordDesc = string.format(
        '**Deleted:** %d vehicles\n**Initiated by:** %s',
        deletedCount,
        initiator
    )
    sendDiscordLog('Vehicle Cleanup Executed', discordDesc, 3447003)
end

local function runCountdownAndCleanup(initiator)
    CreateThread(function()
        sendChatMessage('Vehicle cleanup in 30 seconds! Enter Your Vehicles.')
        Wait(15000)

        sendChatMessage('Vehicle cleanup in 15 seconds! Enter Your Vehicles.')
        Wait(15000)

        cleanupVehicles(initiator)
    end)
end

CreateThread(function()
    while true do
        Wait(CLEANUP_INTERVAL - 30000)
        runCountdownAndCleanup('Automatic Timer')
    end
end)

RegisterCommand('massdv', function(source)

    local initiator = 'Console'
    if source ~= 0 then
        local playerName = GetPlayerName(source)
        local identifiers = GetPlayerIdentifiers(source)
        local steamId = 'Unknown'
        
        for _, id in ipairs(identifiers) do
            if string.match(id, 'steam:') then
                steamId = id
                break
            end
        end
        
        initiator = string.format('%s (%s)', playerName, steamId)
    end

    sendChatMessage('Admin initiated vehicle cleanup!')
    runCountdownAndCleanup(initiator)
end, false)
