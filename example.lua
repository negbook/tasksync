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

load(LoadResourceFile("tasksync", 'tasksync_with_drawmenu.lua.sourcecode'))()

Menu.new = function()
	return {
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
				end 
			elseif key == 'right' then
				if self.items[self.selected.y] and self.items[self.selected.y].options then 
					if self.selected.x < #self.items[self.selected.y].options then
						self.selected.x = self.selected.x + 1
					else
						self.selected.x = 1
					end
				end 
			elseif key == 'return' then
				if self.items[self.selected.y].action then
					self.items[self.selected.y]:action(self.selected.x)
				end
				
				
			end
			self:update(self)
		end,
		draw = function(self)
			Tasksync.MenuDrawInit("testmenu",self.title,self.subtitle,7)
			local buttons = {} 
			for i=1,#self.items do 
				local v = self.items[i]
				table.insert(buttons,v.name)
				if v.description then 
					Tasksync.MenuDrawSetButtonDescription("testmenu",i,v.name)
				end 
				if v.options then 
					Tasksync.MenuDrawSetButtonOptions("testmenu",i,table.unpack(v.options))
				end 
				if v.price and v.icon then
					Tasksync.MenuDrawSetButtonIcon("testmenu",i,Tasksync.MenuDrawGetIcon(v.icon,v.tuneicon or false ))
					Tasksync.MenuDrawSetButtonOptions("testmenu",i,"$"..v.price)
				else 
					if v.icon then 
						Tasksync.MenuDrawSetButtonIcon("testmenu",i,Tasksync.MenuDrawGetIcon(v.icon,v.tuneicon or false))
					end 
					if v.righttext then 
						Tasksync.MenuDrawSetButtonOptions("testmenu",i,v.righttext)
					end 
				end 
			end 
			Tasksync.MenuDrawSetButtons("testmenu",table.unpack(buttons))
			Tasksync.MenuDrawSetSelection("testmenu",1,1)
		end,
		update = function(self)
			local buttons = {} 
			for i=1,#self.items do 
				local v = self.items[i]
				table.insert(buttons,v.name)
				if v.description then 
					Tasksync.MenuDrawSetButtonDescription("testmenu",i,v.name)
				end 
				if v.options then 
					Tasksync.MenuDrawSetButtonOptions("testmenu",i,table.unpack(v.options))
				end 
				if v.price and v.icon then
					Tasksync.MenuDrawSetButtonIcon("testmenu",i,Tasksync.MenuDrawGetIcon(v.icon,v.tuneicon or false ))
					Tasksync.MenuDrawSetButtonOptions("testmenu",i,"$"..v.price)
				else 
					if v.icon then 
						Tasksync.MenuDrawSetButtonIcon("testmenu",i,Tasksync.MenuDrawGetIcon(v.icon,v.tuneicon or false ))
					end 
					if v.righttext then 
						Tasksync.MenuDrawSetButtonOptions("testmenu",i,v.righttext)
					end 
				end 
			end 
			Tasksync.MenuDrawSetButtons("testmenu",table.unpack(buttons))
			Tasksync.MenuDrawSetSelection("testmenu",self.selected.y,self.selected.x)

		end 
	}
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
	testmenu:draw()
	
	load(LoadResourceFile("tasksync", 'tasksync_with_keys.lua.sourcecode'))()
	local group = "MENU_EXAMPLE_GROUP"
	Tasksync.RegisterKeyboardCallback(group,"SELECT2","SPACE","THIS IS MENU SELECT")
	Tasksync.RegisterKeyboardCallback(group,"SHIFT2","TAB","")
	Tasksync.RegisterKeyboardCallback(group,"BACK2","BACK","")
	Tasksync.RegisterKeyboardCallback(group,"ESCAPE2","ESCAPE","")
	Tasksync.RegisterKeyboardCallback(group,"ENTER2","RETURN","")
	Tasksync.RegisterKeyboardCallback(group,"UP2","UP","")
	Tasksync.RegisterKeyboardCallback(group,"DOWN2","DOWN","")
	Tasksync.RegisterKeyboardCallbackLoop(group,"LEFT2","LEFT","",500,50)
	Tasksync.RegisterKeyboardCallbackLoop(group,"RIGHT2","RIGHT","",500,50)

	Tasksync.SetKeyMappingGroupActive("MENU_EXAMPLE_GROUP",true)
	Tasksync.RegisterKeyEvent("MENU_EXAMPLE_GROUP","BACK2",function()
		testmenu:keyPressed("back") 
	end )
	Tasksync.RegisterKeyEvent("MENU_EXAMPLE_GROUP","UP2",function()
		testmenu:keyPressed("up") 
	end )
	Tasksync.RegisterKeyEvent("MENU_EXAMPLE_GROUP","DOWN2",function()
		testmenu:keyPressed("down") 
	end )
	Tasksync.RegisterKeyEvent("MENU_EXAMPLE_GROUP","LEFT2",function()
		testmenu:keyPressed("left") 
	end )
	Tasksync.RegisterKeyEvent("MENU_EXAMPLE_GROUP","LEFT2_HOLDING",function()
		testmenu:keyPressed("left")
	end )
	Tasksync.RegisterKeyEvent("MENU_EXAMPLE_GROUP","RIGHT2",function()
		testmenu:keyPressed("right")
	end )
	Tasksync.RegisterKeyEvent("MENU_EXAMPLE_GROUP","RIGHT2_HOLDING",function()
		testmenu:keyPressed("right")
	end )
	Tasksync.RegisterKeyEvent("MENU_EXAMPLE_GROUP","SELECT2",function()
		testmenu:keyPressed("return") 
	end )
	Tasksync.RegisterKeyEvent("MENU_EXAMPLE_GROUP","ENTER2",function()
		testmenu:keyPressed("return") 
	end )
end) 

CreateThread(function()
	Wait(60000)
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