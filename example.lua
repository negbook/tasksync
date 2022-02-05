load(LoadResourceFile("tasksync", 'tasksync.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_custom.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_once.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_with_scaleform.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_with_drawtext.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_with_keys.lua.sourcecode'))()
CreateThread(function()
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
end)


load(LoadResourceFile("tasksync", 'tasksync_with_drawmenu.lua.sourcecode'))()

Tasksync.MenuDraw("testmenu","negbook","Select your fruit",7,"PI")
Tasksync.SetButtons("testmenu","apple",GetLabelText("DFLT_MNU_OPT"),"banana","banana","banana","banana","banana","banana","banana","banana","banana","banana","banana")
Tasksync.SetButtonDescription("testmenu",1,"this is a apple")
Tasksync.SetButtonDescription("testmenu",2,"this is a banana")

CreateThread(function()
	while true do Wait(1000)
		Tasksync.SetSelection("testmenu",GetRandomIntInRange(-11,33))
	end 

end)
CreateThread(function()
	Wait(20000)
	Tasksync.MenuEnd("testmenu")
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