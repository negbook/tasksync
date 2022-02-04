local Logs = {} 

AddEventHandler("addlooplog",function(resourcename)
	if not Logs[resourcename.."_".. "loop"] then Logs[resourcename.."_".. "loop"] = 0 end 
	Logs[resourcename.."_".. "loop"] = Logs[resourcename.."_".. "loop"] + 1
	
	
end)

AddEventHandler("deletelooplog",function(resourcename)
	if Logs[resourcename.."_".. "loop"] > 0 then 
	Logs[resourcename.."_".. "loop"] = Logs[resourcename.."_".. "loop"] - 1
	end 
end)


AddEventHandler("addloopcustomlog",function(resourcename)
	if not Logs[resourcename.."_".. "loopcustom"] then Logs[resourcename.."_".. "loopcustom"] = 0 end 
	Logs[resourcename.."_".. "loopcustom"] = Logs[resourcename.."_".. "loopcustom"] + 1
end)

AddEventHandler("deleteloopcustomlog",function(resourcename)
	if Logs[resourcename.."_".. "loopcustom"] > 0 then 
	Logs[resourcename.."_".. "loopcustom"] = Logs[resourcename.."_".. "loopcustom"] - 1
	end 
end)


AddEventHandler("addlooponcelog",function(resourcename)
	if not Logs[resourcename.."_".. "looponce"] then Logs[resourcename.."_".. "looponce"] = 0 end 
	Logs[resourcename.."_".. "looponce"]  = Logs[resourcename.."_".. "looponce"]  + 1
end)

AddEventHandler("deletelooponcelog",function(resourcename)
	if Logs[resourcename.."_".. "looponce"] > 0 then 
	Logs[resourcename.."_".. "looponce"]  = Logs[resourcename.."_".. "looponce"]  - 1
	end 
end)

AddEventHandler('onResourceStop', function(resourcename)
  if Logs[resourcename.."_".. "loop"] and Logs[resourcename.."_".. "loop"] > 0 then 
	Logs[resourcename.."_".. "loop"] = 0
  end 
  if Logs[resourcename.."_".. "loopcustom"] and Logs[resourcename.."_".. "loopcustom"] > 0 then 
	Logs[resourcename.."_".. "loopcustom"] = 0
  end
  if Logs[resourcename.."_".. "looponce"] and Logs[resourcename.."_".. "looponce"] > 0 then 
	Logs[resourcename.."_".. "looponce"] = 0
  end
end)


local function IsServer() return IsDuplicityVersion() end ;
local function IsClient() return not IsDuplicityVersion() end ;
local function IsShared() return true end ;
if IsClient() then 
Command = setmetatable({},{__newindex=function(t,k,fn) RegisterCommand(k,function(source, args, raw) fn(table.unpack(args)) end) return end })
	Command["tasksync_log"] = function()
		for i,v in pairs(Logs) do 
			print("Client",i,v)
		end 
	end 
else 
ClientCommand = setmetatable({},{__newindex=function(t,k,fn) RegisterCommand(k,function(source, args, raw) if source>0 then fn(source,table.unpack(args)) end end) return end })
ServerCommand = setmetatable({},{__newindex=function(t,k,fn) RegisterCommand(k,function(source, args, raw) if source>0 then else fn(table.unpack(args)) end end) return end })
SharedCommand = setmetatable({},{__newindex=function(t,k,fn) RegisterCommand(k,function(source, args, raw) fn(source,table.unpack(args)) end) return end })
	ServerCommand["tasksync_log"] = function(a)
		for i,v in pairs(Logs) do 
			print("Server",i,v)
		end 
	end 
end 