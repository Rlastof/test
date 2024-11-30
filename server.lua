local report_count = 0
local reports = {}

local function debugLog(message)
    if Config.DebugMode then
        print("[Backdoor Scanner] " .. message)
    end
end

local function isAdmin(source)
    return IsPlayerAceAllowed(source, "command." .. Config.CommandName)
end

local function scan_file(file_path)
    debugLog("Scanning file: " .. file_path)
    local file = io.open(file_path, "r")
    if not file then return { status = "unreadable", details = {} } end

    local content = file:read("*all")
    file:close()

    local patterns = {
        { pattern = "loadstring", description = "Dinamik kod çalıştırma." },
        { pattern = "RunCode", description = "Uzaktan kod çalıştırma." },
        { pattern = "assert%(load%(", description = "Potansiyel backdoor." },
        { pattern = "os%.execute", description = "Komut satırı erişimi." },
        { pattern = "TriggerServerEvent%(.-'%-remote%-'%))", description = "Zararlı sunucu çağrısı." }
    }

    local matches = {}

    for _, rule in ipairs(patterns) do
        for line in content:gmatch("[^\r\n]+") do
            if line:find(rule.pattern) then
                table.insert(matches, { line = line, description = rule.description })
            end
        end
    end

    if #matches > 0 then
        debugLog("Malicious patterns found!")
        return { status = "malicious", details = matches }
    elseif content:find("[A-Za-z0-9+/=]{100,}") then
        debugLog("Suspicious patterns found!")
        return { status = "suspicious", details = { { line = "Base64 veya şifrelenmiş kod bulundu.", description = "Kod gizleme olabilir." } } }
    else
        debugLog("No issues found.")
        return { status = "safe", details = {} }
    end
end

local function scan_scripts()
    debugLog("Scanning all scripts...")
    local results = { safe = 0, suspicious = 0, malicious = 0, details = {} }
    for _, resource in ipairs(GetResources()) do
        local path = GetResourcePath(resource)
        if path then
            debugLog("Scanning resource: " .. resource) -- Tarama sırasında loglama
            local manifest = path .. "/fxmanifest.lua"
            local scan_result = scan_file(manifest)
            results.details[resource] = scan_result
            results[scan_result.status] = (results[scan_result.status] or 0) + 1
        else
            debugLog("Resource path not found for: " .. resource) -- Path bulunamazsa loglama
        end
    end
    debugLog("Scanning completed. Results: " .. json.encode(results)) -- Tarama sonrası sonuç loglama
    return results
end

-- Yeni eklenen loglama ve düzenleme: Komut tetikleyicisi
RegisterCommand(Config.CommandName, function(source, args, rawCommand)
    if Config.AdminOnly and not isAdmin(source) then
        TriggerClientEvent("scanner:notify", source, "Bu komutu yalnızca adminler kullanabilir.")
        debugLog("Non-admin player attempted to use the command.") -- Log: Admin olmayan denemesi
        return
    end

    debugLog("Command executed: " .. Config.CommandName) -- Komut çalıştırıldığında log

    local report_id = report_count
    local report = reports[report_id]

    -- Eğer rapor yoksa istemciye bildir
    if not report then
        debugLog("No report found for ID: " .. report_id)
        TriggerClientEvent("scanner:notify", source, "Rapor bulunamadı.")
        return
    end

    -- Rapor istemciye gönderiliyor
    debugLog("Sending report to client: " .. json.encode(report))
    TriggerClientEvent("scanner:showReport", source, {
        safe = report.safe,
        suspicious = report.suspicious,
        malicious = report.malicious,
        details = report.details
    })
    debugLog("Report sent to client successfully.") -- Log: Başarılı gönderim
end)

-- "onResourceStart" için herhangi bir otomatik tetikleme yapılmaz.
AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        debugLog("Resource started: " .. resource) -- Log: Resource başladı
    end
end)

-- Resource tetikleyicisi: Rapor oluşturma
AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then return end
    report_count = report_count + 1
    local result = scan_scripts()
    reports[report_count] = result
    SaveResourceFile(GetCurrentResourceName(), "raporlar/rapor_" .. report_count .. ".json", json.encode(result), -1)
    debugLog("New report generated: #" .. report_count) -- Log: Yeni rapor
end)
