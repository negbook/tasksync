load(LoadResourceFile("tasksync", 'tasksync.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_custom.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_once.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_with_scaleform.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_with_drawtext.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_with_keys.lua.sourcecode'))()
CreateThread(function()
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
load(LoadResourceFile("tasksync", 'tasksync_with_drawmenu.lua.sourcecode'))()

CreateThread(function()
	local self = {}
	self.title = "negbook"
	self.subtitle = "hello"
	self.maxslot = 7
	self.buttons = {
		{name="apple",description="hello",options={"a","b"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		
	}
	self.selected = {y = 2,x = 2}
	local isUpdate = false 
	Tasksync.MenuDrawInit( self.title,self.subtitle,self.maxslot or 7,true)
	local buttonnames = {} 
	for i=1,#self.buttons do 
		local v = self.buttons[i]
		if not isUpdate then 
			table.insert(buttonnames,v.name)
		end 
	end
	if not isUpdate then 
		Tasksync.MenuDrawSetButtons(table.unpack(buttonnames))
	end 
	for i=1,#self.buttons do 
		local v = self.buttons[i]
		if v.description then 
			Tasksync.MenuDrawSetButtonDescription(i,v.description)
		end 
		if v.options then 
			Tasksync.MenuDrawSetButtonOptions(i,table.unpack(v.options))
			--if v.selected then Tasksync.MenuDrawSetSlotSelection(i,v.selected) end
		end 
		if v.icon then 
			Tasksync.MenuDrawSetButtonIcon(i,Tasksync.MenuDrawGetIcon(v.icon,v.tuneicon or false))
		end 
		if v.righttext then 
			Tasksync.MenuDrawSetButtonOptions(i,v.righttext)
		end 
	end 
	
	
	--Tasksync.MenuDrawSetSelection(self.selected.y,self.selected.x)
	if not isUpdate then 
		Tasksync.MenuCheckGlareType(self.menutype)
		Tasksync.MenuDrawRender()
	end 
	--[[
	Wait(8000)
	Tasksync.SetKeyGroupActive("GROUP_TASKSYNC_DRAWMENU",false)
	Tasksync.MenuDrawEnd()--]]
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