local function debugLog(message)
    if Config.DebugMode then
        print("[Backdoor Scanner] " .. message)
    end
end

RegisterNetEvent("scanner:showReport", function(report)
    debugLog("Received report data from server.")
    SendNUIMessage({
        type = "report",
        report = report
    })
    SetNuiFocus(true, true) -- Arayüzü ve fareyi etkinleştir
end)

RegisterNetEvent("scanner:showScriptDetails", function(script, details)
    debugLog("Showing script details for: " .. script)
    SendNUIMessage({
        type = "scriptDetails",
        script = script,
        details = details
    })
    SetNuiFocus(true, true) -- Arayüzü ve fareyi etkinleştir
end)

RegisterCommand(Config.CommandName, function()
    debugLog("Opening NUI with command.")
    SendNUIMessage({
        type = "open"
    })
    SetNuiFocus(true, true) -- Fareyi etkinleştir
end)

RegisterNUICallback("closeModal", function(data, cb)
    debugLog("Closing NUI.")
    SetNuiFocus(false, false) -- Fare ve klavye girdisini devre dışı bırak
    cb("ok")
end)
