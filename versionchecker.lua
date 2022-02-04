_Prefix = '^2[tasksync]^0'
_VERSION = LoadResourceFile(GetCurrentResourceName(), "version") or 0

-- Server
--print(os.time(os.date("!*t")))
-- Version check
local VersionAPIRequest = "https://raw.githubusercontent.com/negbook/updates_log/main/updates.log"

function performVersionCheck()
	
	PerformHttpRequest(VersionAPIRequest, function(err, rText, headers)
		local dtbl = json.decode(rText)
		local decoded 
		if dtbl then 
			for i,v in pairs(dtbl) do 
				if v.name ==GetCurrentResourceName() then 
					decoded = v
					
				end 
			end 
		end 
		
		if err == 200 then
			if decoded and decoded.version and tonumber(decoded.version) > tonumber(_VERSION) then 
			    print("Version Outdated.Visit https://github.com/negbook/tasksync to get newest version.")
			else 
				print("Up-to-date.")
			
			end 
		else
			print(_Prefix .. " Updater version: UPDATER UNAVAILABLE")
			print(_Prefix .. " This could be your internet connection or that the update server is not running. This won't impact the server\n\n")
		
			
		end
	end, "GET", "", {what = 'this'})
end
-- Perform version check periodically while server is running. To notify of updates.
Citizen.CreateThread(function()
	while true do
		performVersionCheck()
		Citizen.Wait(3600000)
	end
end)