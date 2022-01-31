Tasksync = {}
load(LoadResourceFile("tasksync", 'tasksync.lua'))()
load(LoadResourceFile("tasksync", 'tasksync_custom.lua'))()
load(LoadResourceFile("tasksync", 'tasksync_once.lua'))()

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

