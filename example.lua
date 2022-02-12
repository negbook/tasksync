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
load(LoadResourceFile("tasksync", 'tasksync_with_menu.lua.sourcecode'))()
CreateThread(function() 
	testmenu = Tasksync.NativeMenuGen()
	testmenu:setHeader("negbook","subtitle",6,"PI")
	testmenu:addItem{
		name = "apple",
		options = {"a","b","c"},
		action = function(self,optionselection) 
			print(self.options[optionselection])
		end,
		description = "select your apple color"
	}
	testmenu:addItem{
		name = "apple",
		icon = 12,
		action = function(self,optionselection) 
			self.tuneicon = not self.tuneicon
		end,
		price = 300
	}
	testmenu:addItem{
		name = "apple",
		righttext = "asdasd"
	}
	testmenu:addItem{
		name = "apple",
		righttext = "asdasd",
		icon = 13
	}
	testmenu:addItem{
		name = "check",
		action = function(self,optionselection) 
			self.tuneicon = not self.tuneicon
		end,
		icon = 17
	}
	testmenu:addItem{
		name = "apple",
		price = 4000,
		icon = 13
	}
	
	testmenu:addItem{
		name = "Draw new menu",
		action = function(self)
			local 	testmenu2 = Tasksync.NativeMenuGen()
			testmenu2:setHeader("negbook2","subtitle2",7)
			testmenu2:addItem{
				name = "appl2e",
				options = {"a","b","c"},
				action = function(self,optionselection) 
					print(self.options[optionselection])
				end
			}
			testmenu2:addItem{
				name = "app3le",
				icon = 12,
				action = function(self,optionselection) 
					self.tuneicon = not self.tuneicon
				end,
				price = 300
			}
			testmenu2:addItem{
				name = "ap2ple",
				righttext = "asdasd"
			}
			testmenu2:addItem{
				name = "apple",
				righttext = "asdasd",
				icon = 13
			}
			testmenu2:addItem{
				name = "apple",
				price = 4000,
				icon = 13
			}
			testmenu2:addItem{
			name = "Draw new menu",
			action = function(self)
				local 	testmenu3 = Tasksync.NativeMenuGen()
				testmenu3:setHeader("negbook3","subtitle3",7)
				testmenu3:addItem{
					name = "appl2e",
					options = {"a","b","c"},
					action = function(self,optionselection) 
						print(self.options[optionselection])
					end
				}
				testmenu3:addItem{
					name = "app3le",
					icon = 12,
					action = function(self,optionselection) 
						self.tuneicon = not self.tuneicon
					end,
					price = 300
				}
				testmenu3:addItem{
					name = "ap2ple",
					righttext = "asdasd"
				}
				testmenu3:addItem{
					name = "apple",
					righttext = "asdasd",
					icon = 13
				}
				testmenu3:addItem{
					name = "apple",
					price = 4000,
					icon = 13
				}
				testmenu3:draw()
			end 
		}
			testmenu2:draw()
		end 
	}
	testmenu:draw()
	
end) 
CreateThread(function()
	Wait(60000)
	Tasksync.MenuDrawEnd("testmenu")
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