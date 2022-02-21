load(LoadResourceFile("tasksync", 'tasksync.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_once.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_with_scaleform.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_with_drawtext.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_with_keys.lua.sourcecode'))()
CreateThread(function()
	--[[
	local rand = 2000
	Tasksync.addlooponce("norma0",1000,function(setter)
		print("norma0",0)
		rand = math.floor(math.random(1,3)) * 100
	end )
	
	Tasksync.addlooponce("norma0",200,function(setter)
		print("normal",setter:get())
		
		setter:set(rand)
	end )
	
	Tasksync.addloop("normal2",3000,function(setter)
		print("normal2",setter:get())
		setter:set(rand)
	end )
	
	Tasksync.addloop("normal3",1500,function(setter)
		print("normal3",setter:get())
		setter:set(rand)
	end )
	Wait(3000)
	print('delete')
	
	Tasksync.deletelooponce("norma0",1000)
	--]]
	--[[
	if not Tasksync.ScaleformIsDrawing("SHOP_MENU_DLC") then 
		local width = 220
		local height = 250 

		Tasksync.ScaleformDraw("SHOP_MENU_DLC",function(initialise,stopafter)
			initialise("SET_TITLE","Title")
			initialise("SET_DATA_SLOT",0,0,0,0,1000,"name")
			initialise("SET_DATA_SLOT",1,0,0,0,1000,"name2")
			initialise("SET_DESCRIPTION","SET_DESCRIPTION1","SET_DESCRIPTION2","SET_DESCRIPTION3")
			initialise("SET_IMAGE","","")
			initialise("DRAW_MENU_LIST")
			stopafter(3000)
		end) 
	end 
	--]]
	
	--[[
	local handle = TextDrawCreate(0.4,0.4,"test")
	TextDrawShow(handle)
	while true do Wait(0)
		local cx,cy = GetNuiCursorPosition()
		local sw,sh = GetActiveScreenResolution()
		local x,y = cx/sw,cy/sh
		TextDrawSetPosition(handle,x,y)
	end 
	--]]
	--[[
	
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	local handle = Create3DTextLabel("test3d",0xff0000ff,0,x,y,z,50.0)
	
	local handle = Create3DTextLabel("test3dentity",0xff0000ff,0,x,y,z,50.0)
	Attach3DTextLabelToEntity(handle,PlayerPedId(),0.0,0.0,0.0)
	local handle = Create3DTextLabel("test3dentity2",0xff0000ff,0,x,y,z,50.0)
	Attach3DTextLabelToPlayer(handle,PlayerId(),0.0,0.0,0.0)
	
	Tasksync.ScaleformDraw("mp_big_message_freemode",function(initialise)
		initialise("SHOW_SHARD_WASTED_MP_MESSAGE","Big Text","Smaller Text",5)
	end,1)
	
	--[=[
	Tasksync.ScaleformDrawMini("mp_big_message_freemode",0.5,0.25,0.8,0.8,255,255,255,255,0,function(initialise)
		initialise("SHOW_SHARD_WASTED_MP_MESSAGE","Big Text","Smaller Text",5)
	end,1)
	--]=]
	Tasksync.ScaleformCall("mp_big_message_freemode",function(run)
		run("SHOW_SHARD_WASTED_MP_MESSAGE","Big Text","Smaller Text",5)
	end)
	
	Wait(8000)
	Tasksync.ScaleformEnd("mp_big_message_freemode")
	--]]
end)



--[=[
local i = 1
Tasksync.addloop("test",1000,function()
	print(1)
	
	i = 0
	Tasksync.addlooponce("test",100,function()
		i = i + 1
		print(i)
	end)
end)

Tasksync.addloop("test2",2000,function()
	print(2)
end)

Tasksync.addloopcustom("test",1000,function(delay)
	print(3000)
	delay.setter(3000)
end)

--]=]

local function IsServer() return IsDuplicityVersion() end ;
local function IsClient() return not IsDuplicityVersion() end ;
local function IsShared() return true end ;
if IsClient() then 
Command = setmetatable({},{__newindex=function(t,k,fn) RegisterCommand(k,function(source, args, raw) fn(table.unpack(args)) end) return end })
	Command["tasksync_debug"] = function()
		TriggerEvent("Tasksync:ShowDebug")
	end 
else 
ClientCommand = setmetatable({},{__newindex=function(t,k,fn) RegisterCommand(k,function(source, args, raw) if source>0 then fn(source,table.unpack(args)) end end) return end })
ServerCommand = setmetatable({},{__newindex=function(t,k,fn) RegisterCommand(k,function(source, args, raw) if source>0 then else fn(table.unpack(args)) end end) return end })
SharedCommand = setmetatable({},{__newindex=function(t,k,fn) RegisterCommand(k,function(source, args, raw) fn(source,table.unpack(args)) end) return end })
	ServerCommand["tasksync_log"] = function(a)
		TriggerEvent("Tasksync:ShowDebug")
	end 
end 