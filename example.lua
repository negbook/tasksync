load(LoadResourceFile("tasksync", 'tasksync.lua'))()
load(LoadResourceFile("tasksync", 'tasksync_custom.lua'))()
load(LoadResourceFile("tasksync", 'tasksync_once.lua'))()
load(LoadResourceFile("tasksync", 'tasksync_with_scaleform.lua'))()
CreateThread(function()
	local layer, x ,y ,width ,height ,red ,green ,blue ,alpha ,unk = 1,0.5,0.25,0.8,0.8,255,255,255,255,0
	Tasksync.ScaleformDraw("mp_big_message_freemode",function(initialise)
		--initialise("SHOW_SHARD_WASTED_MP_MESSAGE","Big Text","Smaller Text",5)
	end,1,0.5,0.25,0.8,0.8,255,255,255,255,0)
	Tasksync.ScaleformCall("mp_big_message_freemode",function(run)
		run("SHOW_SHARD_WASTED_MP_MESSAGE","Big Text","Smaller Text",5)
	end)
	Wait(3000)
	Tasksync.ScaleformEnd("mp_big_message_freemode")
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