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

Menu = {}
Menus = {} 
load(LoadResourceFile("tasksync", 'tasksync_with_drawmenu.lua.sourcecode'))()


Menu.new = function()
	local menu = {
		items = {},
		options = {},
		selected = {y=1,x=1},
		setTitle = function(self, title)
			self.title = title
		end,
		setSubtitle = function(self, subtitle)
			self.subtitle = subtitle
		end,
		addItem = function(self, item)
			table.insert(self.items, item)
		end,
		keyPressed = function(self, key)
			if key == 'up' then
				if self.selected.y > 1 then
					self.selected.y = self.selected.y - 1
				else
					self.selected.y = #self.items
				end
			elseif key == 'down' then
				if self.selected.y < #self.items then
					self.selected.y = self.selected.y + 1
				else
					self.selected.y = 1
				end
			elseif key == 'left' then
				if self.items[self.selected.y] and self.items[self.selected.y].options then 
					if self.selected.x > 1 then
						self.selected.x = self.selected.x - 1
					else
						self.selected.x = #self.items[self.selected.y].options
					end
					self.items[self.selected.y].selected = self.selected.x
				end 
			elseif key == 'right' then
				if self.items[self.selected.y] and self.items[self.selected.y].options then 
					if self.selected.x < #self.items[self.selected.y].options then
						self.selected.x = self.selected.x + 1
					else
						self.selected.x = 1
					end
					self.items[self.selected.y].selected = self.selected.x
				end 
			elseif key == 'back' then
				if Menus and #Menus > 0 then 
					Menus[#Menus]:drawend()
					table.remove(Menus,#Menus)
					if Menus[#Menus] then 
						Menus[#Menus]:draw()

					end 
				else 
					self:drawend(self)
				end 
			end 
			self:update(self)
			if key == 'return' then
				if self.items[self.selected.y].action then
					self.items[self.selected.y]:action(self.selected.x)
				end
				
				
			end
			
		end,
		draw = function(self)
			Tasksync.MenuDrawInit("menu:"..self.title,self.title,self.subtitle,7)
			local buttons = {} 
			for i=1,#self.items do 
				local v = self.items[i]
				table.insert(buttons,v.name)
				if v.description then 
					Tasksync.MenuDrawSetButtonDescription("menu:"..self.title,i,v.name)
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
			Tasksync.MenuDrawSetButtons("menu:"..self.title,table.unpack(buttons))
			Tasksync.MenuDrawSetSelection("menu:"..self.title,self.selected.y,self.selected.x)
			
		end,
		drawend = function(self)
			Tasksync.MenuDrawEnd("menu:"..self.title)
		end,
		update = function(self)
			local buttons = {} 
			for i=1,#self.items do 
				local v = self.items[i]
				table.insert(buttons,v.name)
				if v.description then 
					Tasksync.MenuDrawSetButtonDescription("menu:"..self.title,i,v.name)
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
						Tasksync.MenuDrawSetButtonIcon("menu:"..self.title,i,Tasksync.MenuDrawGetIcon(v.icon,v.tuneicon or false ))
					end 
					if v.righttext then 
						Tasksync.MenuDrawSetButtonOptions("menu:"..self.title,i,v.righttext)
					end 
				end 
			end 
			Tasksync.MenuDrawSetButtons("menu:"..self.title,table.unpack(buttons))
			Tasksync.MenuDrawSetSelection("menu:"..self.title,self.selected.y,self.selected.x)

		end 
	}
	table.insert(Menus,menu)
	return menu
end

CreateThread(function() 
	testmenu = Menu.new()
	testmenu:setTitle("negbook")
	testmenu:setSubtitle("subtitle")
	testmenu:addItem{
		name = "apple",
		options = {"a","b","c"},
		action = function(self,optionselection) 
			print(self.options[optionselection])
		end
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
		name = "apple",
		price = 4000,
		icon = 13
		
	}
	testmenu:addItem{
		name = "Draw new menu",
		action = function(self)
			local 	testmenu2 = Menu.new()
			testmenu2:setTitle("negbook2")
			testmenu2:setSubtitle("subtitle2")
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
			testmenu:drawend()
			testmenu2:draw()
		end 
	}
	testmenu:draw()
	
	load(LoadResourceFile("tasksync", 'tasksync_with_keys.lua.sourcecode'))()
	local group = "MENU_LIB_GROUP"
	Tasksync.RegisterKeyboardCallback(group,"SELECT2","SPACE","THIS IS MENU SELECT")
	Tasksync.RegisterKeyboardCallback(group,"SHIFT2","TAB","")
	Tasksync.RegisterKeyboardCallback(group,"BACK2","BACK","")
	Tasksync.RegisterKeyboardCallback(group,"ESCAPE2","ESCAPE","")
	Tasksync.RegisterKeyboardCallback(group,"ENTER2","RETURN","")
	Tasksync.RegisterKeyboardCallback(group,"UP2","UP","")
	Tasksync.RegisterKeyboardCallback(group,"DOWN2","DOWN","")
	Tasksync.RegisterKeyboardCallbackLoop(group,"LEFT2","LEFT","",500,50)
	Tasksync.RegisterKeyboardCallbackLoop(group,"RIGHT2","RIGHT","",500,50)

	Tasksync.SetKeyMappingGroupActive("MENU_LIB_GROUP",true)
	Tasksync.RegisterKeyEvent("MENU_LIB_GROUP","BACK2",function()
		if Menus and Menus[#Menus] then 
			Menus[#Menus]:keyPressed("back") 
		end 
	end )
	Tasksync.RegisterKeyEvent("MENU_LIB_GROUP","UP2",function()
		if Menus and Menus[#Menus] then 
		Menus[#Menus]:keyPressed("up") 
		end
	end )
	Tasksync.RegisterKeyEvent("MENU_LIB_GROUP","DOWN2",function()
		if Menus and Menus[#Menus] then 
		Menus[#Menus]:keyPressed("down") 
		end
	end )
	Tasksync.RegisterKeyEvent("MENU_LIB_GROUP","LEFT2",function()
		if Menus and Menus[#Menus] then 
		Menus[#Menus]:keyPressed("left") 
		end
	end )
	Tasksync.RegisterKeyEvent("MENU_LIB_GROUP","LEFT2_HOLDING",function()
		if Menus and Menus[#Menus] then 
		Menus[#Menus]:keyPressed("left") 
		end
	end )
	Tasksync.RegisterKeyEvent("MENU_LIB_GROUP","RIGHT2",function()
		if Menus and Menus[#Menus] then 
		Menus[#Menus]:keyPressed("right") 
		end
	end )
	Tasksync.RegisterKeyEvent("MENU_LIB_GROUP","RIGHT2_HOLDING",function()
		if Menus and Menus[#Menus] then 
		Menus[#Menus]:keyPressed("right") 
		end
	end )
	Tasksync.RegisterKeyEvent("MENU_LIB_GROUP","SELECT2",function()
		if Menus and Menus[#Menus] then 
		Menus[#Menus]:keyPressed("return")
		end
	end )
	Tasksync.RegisterKeyEvent("MENU_LIB_GROUP","ENTER2",function()
		if Menus and Menus[#Menus] then 
		Menus[#Menus]:keyPressed("return") 
		end 
	end )
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