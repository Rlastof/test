RegisterCommand("scanscripts", function(source, args, rawCommand)
    print("[Backdoor Scanner] Script scanning initiated...")
    TriggerClientEvent("scanner:showReport", source, {
        safe = 10,
        suspicious = 2,
        malicious = 1,
        details = {
            ["example_script"] = { status = "safe", details = {} },
            ["suspicious_script"] = { status = "suspicious", details = {"Some warning"} },
            ["malicious_script"] = { status = "malicious", details = {"Detected backdoor"} }
        }
    })
end, true)
