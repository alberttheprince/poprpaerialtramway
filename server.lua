local riding = {}        -- [src] = true while that player is on a tram

-- Shared clock: echo the client's send-time back with our timer for NTP sync
RegisterNetEvent('tramway:syncReq', function(t0)
    TriggerClientEvent('tramway:syncRes', source, t0, GetGameTimer())
end)

-- Logout-while-riding rescue
local function licenseOf(src)
    return GetPlayerIdentifierByType(src, 'license') or ('src:' .. src)
end
local function dangleKey(src)
    return 'tramway_dangle_' .. (licenseOf(src):gsub('[^%w]', '_'))
end

RegisterNetEvent('tramway:riding', function(state)
    if state then riding[source] = true else riding[source] = nil end
end)

AddEventHandler('playerDropped', function()
    local src = source
    if riding[src] then
        SetResourceKvpInt(dangleKey(src), 1)
        riding[src] = nil
    end
end)

RegisterNetEvent('tramway:checkDangle', function()
    local src = source
    local key = dangleKey(src)
    if GetResourceKvpInt(key) == 1 then
        DeleteResourceKvp(key)
        TriggerClientEvent('tramway:goToStation', src)
    end
end)

-- Switching characters (not a disconnect): forget their riding state
local function clearRiding(src) riding[src or source] = nil end
AddEventHandler('QBCore:Server:OnPlayerUnload', clearRiding)
AddEventHandler('qbx_core:server:onPlayerUnloaded', clearRiding)
