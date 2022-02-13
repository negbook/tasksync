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
load(LoadResourceFile("tasksync", 'tasksync_with_keys.lua.sourcecode'))()
local shared_cb = function(input)
	print(input)
end
Tasksync.RegisterKeyTable{
	group = "GROUP_TASKSYNC_DRAWMENU",
	keys = {
		{"TAB","THIS IS MENU TAB"},
		{"BACK","THIS IS MENU BACK"},
		{"SPACE","THIS IS MENU SPACE"},
		{"ESCAPE","THIS IS MENU ESCAPE"},
		{"RETURN","THIS IS MENU RETURN"},
		{"UP","THIS IS MENU UP"},
		{"DOWN","THIS IS MENU DOWN"},
		{"IOM_WHEEL_UP","THIS IS MENU IOM_WHEEL_UP"},
		{"IOM_WHEEL_DOWN","THIS IS MENU IOM_WHEEL_DOWN"},
		{"LEFT","THIS IS MENU LEFT",500,50},
		{"RIGHT","THIS IS MENU RIGHT",500,50}
	},
	cbs = {
		{"BACK","JUST_PRESSED",shared_cb,"back"},
		{"UP","JUST_PRESSED",shared_cb,"up"},
		{"DOWN","JUST_PRESSED",shared_cb,"down"},
		{"LEFT","JUST_PRESSED",shared_cb,"left"},
		{"LEFT","PRESSED",shared_cb,"left"},
		{"RIGHT","JUST_PRESSED",shared_cb,"right"},
		{"RIGHT","PRESSED",shared_cb,"right"},
		{"SPACE","JUST_PRESSED",shared_cb,"return"},
		{"RETURN","JUST_PRESSED",shared_cb,"return"},
		{"IOM_WHEEL_UP","JUST_PRESSED",shared_cb,"IOM_WHEEL_UP"},
		{"IOM_WHEEL_DOWN","JUST_PRESSED",shared_cb,"IOM_WHEEL_DOWN"}
	}
}
Tasksync.SetKeyGroupActive("GROUP_TASKSYNC_DRAWMENU",true)
CreateThread(function()
	local self = {}
	self.title = "negbook"
	self.subtitle = "hello"
	self.maxslot = 7
	self.items = {
		{name="apple",description="hello",options={"a","b"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}},
		{name="appl123e",description="hell312o",options={"zxc","basd"}}
	}
	self.selected = {y = 2,x = 2}
	local isUpdate = false 
	Tasksync.MenuDrawInit("menu:"..self.title, self.title,self.subtitle,self.maxslot or 7)
	local buttons = {} 
	for i=1,#self.items do 
		local v = self.items[i]
		if not isUpdate then 
			table.insert(buttons,v.name)
		end 
		if v.description then 
			Tasksync.MenuDrawSetButtonDescription("menu:"..self.title,i,v.description)
		end 
		if v.options then 
			Tasksync.MenuDrawSetButtonOptions("menu:"..self.title,i,table.unpack(v.options))
			if v.selected then Tasksync.MenuDrawSetSlotValue("menu:"..self.title,i,v.selected) end
		end 
		if v.price and v.icon then
			Tasksync.MenuDrawSetButtonIcon("menu:"..self.title,i,Tasksync.MenuDrawGetIcon(v.icon,v.tuneicon or false ))
			Tasksync.MenuDrawSetButtonOptions("menu:"..self.title,i,"$"..v.price)
		else 
			if v.icon then 
				Tasksync.MenuDrawSetButtonIcon("menu:"..self.title,i,Tasksync.MenuDrawGetIcon(v.icon,v.tuneicon or false))
			end 
			if v.righttext then 
				Tasksync.MenuDrawSetButtonOptions("menu:"..self.title,i,v.righttext)
			end 
		end 
	end 
	if not isUpdate then 
		Tasksync.MenuDrawSetButtons("menu:"..self.title,table.unpack(buttons))
	end 
	
	Tasksync.MenuDrawSetSelection("menu:"..self.title,self.selected.y,self.selected.x)
	if not isUpdate then 
		Tasksync.MenuCheckGlareType(self.menutype)
		Tasksync.MenuDrawRender("menu:"..self.title)
	end 
	
	Wait(8000)
	Tasksync.SetKeyGroupActive("GROUP_TASKSYNC_DRAWMENU",false)
	Tasksync.MenuDrawEnd("menu:"..self.title)
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