local function debugLog(message)
    if Config.DebugMode then
        print("[Backdoor Scanner] " .. message)
    end
end

-- Admin kontrolü
local function isPlayerAdmin()
    return IsPlayerAceAllowed(PlayerId(), "command")
end

RegisterNetEvent("scanner:showReport", function(report)
    debugLog("Received report data from server.")
    SendNUIMessage({
        type = "report",
        report = report
    })
    SetNuiFocus(true, true) -- Arayüz ve fareyi etkinleştir
end)

RegisterNetEvent("scanner:showScriptDetails", function(script, details)
    debugLog("Showing script details for: " .. script)
    SendNUIMessage({
        type = "scriptDetails",
        script = script,
        details = details
    })
    SetNuiFocus(true, true) -- Arayüz ve fareyi etkinleştir
end)

RegisterCommand(Config.CommandName, function()
    if Config.AdminOnly and not isPlayerAdmin() then
        print("[Backdoor Scanner] Bu komut sadece adminler tarafından kullanılabilir.")
        return
    end

    debugLog("Opening NUI with command.")
    SendNUIMessage({
        type = "open"
    })
    SetNuiFocus(true, true) -- Fareyi etkinleştir
end)

RegisterNUICallback("closeModal", function(data, cb)
    debugLog("Closing NUI.")
    SetNuiFocus(false, false) -- Fareyi devre dışı bırak
    cb("ok")
end)

RegisterCommand(Config.CommandName, function()
    if Config.AdminOnly and not isPlayerAdmin() then
        print("[Backdoor Scanner] Bu komut sadece adminler tarafından kullanılabilir.")
        return
    end

    debugLog("Opening NUI with command.")
    SendNUIMessage({
        type = "open"
    })
    SetNuiFocus(true, true) -- Fareyi etkinleştir
end)