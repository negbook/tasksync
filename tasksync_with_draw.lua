if not Tasksync then 
	Tasksync = setmetatable({},{})
end 

Tasksync.tasksjob = {}
Tasksync.taskstodo = {}
Tasksync.__createbytemplate = function(durationgroup)
	CreateThread(function()
		local jobs = Tasksync.tasksjob
		local todo = Tasksync.taskstodo
		local tasks = jobs[durationgroup]
		repeat
			if tasks then 
				for i=1,#tasks do 
					local jobname = tasks[i]
					local fn = todo[jobname]
					if fn then fn() end 
				end 
			end 
			Wait(durationgroup)
		until not tasks 
		--print('breaked2')
		return 
	end)
end 	
Tasksync.addloop = function(jobname,durationgroup,fn) --jobname,duration,function
	if Tasksync.taskstodo[jobname] ~= nil then error('Duplicated taskjob: '..jobname, 2) ; return end 
	Tasksync.taskstodo[jobname] = fn 
	local creatable = false 
	if Tasksync.tasksjob[durationgroup] == nil then creatable = true; Tasksync.tasksjob[durationgroup] = {}; end 
	table.insert(Tasksync.tasksjob[durationgroup],jobname)
	if creatable then 
		Tasksync.__createbytemplate(durationgroup)
	end 
end 
Tasksync.deleteloop = function(jobname)
	for durationgroup,v in pairs(Tasksync.tasksjob) do 
		for i=1,#Tasksync.tasksjob[durationgroup] do 
			if Tasksync.tasksjob[durationgroup][i] == jobname then 
				Tasksync.taskstodo[jobname] = nil 
				table.remove(Tasksync.tasksjob[durationgroup],i)
				if #Tasksync.tasksjob[durationgroup] == 0 then 
					Tasksync.tasksjob[durationgroup] = nil
				end 
			end 
		end 
	end 
end 

	Draw3DTexts = {}
	Draw3DTextIndex = 0
	Delete3DTextLabel = function(handle)
		Tasksync.deleteloop(Draw3DTexts[handle].actionname)
	end 
	DrawText3D = function(coords, text, textsizeX,textsizeY,width,height,font,color,outline,usebox,boxcolor)
		
		
		SetScriptGfxDrawOrder(1)
		SetTextScale(textsizeX, textsizeY)
		SetTextFont(font)
		SetTextColour(table.unpack(color))
		if outline > 0  then 
			SetTextOutline()
		end 
		SetTextCentre(true)
		BeginTextCommandDisplayText('STRING')
		AddTextComponentSubstringPlayerName(text)
		SetDrawOrigin(coords, 0)
		EndTextCommandDisplayText(0.0, 0.0)
		if usebox > 0  then 
			SetScriptGfxDrawOrder(0)
			DrawRect(0.0, 0.0+height/2+height/4,width,height,table.unpack(boxcolor))
		end 
		ClearDrawOrigin()
		
		
	end
	Create3DTextLabel = function(text, color, font, x, y, z, drawdistance, virtualworld, testLOS) --virtualworld : RoutingBucket
		local coords = vector3(x, y, z)
		Draw3DTextIndex = Draw3DTextIndex + 1
		local handle = Draw3DTextIndex
		local actionname = "Draw3DTextIndex"..Draw3DTextIndex
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(text)
		width = EndTextCommandGetWidth(1)
		local height = GetRenderedCharacterHeight(0.5,0)
		Draw3DTexts[handle] = {actionname =  actionname,attachentity = nil,drawdistance=drawdistance,coords=coords,textsizeX=0.5,textsizeY=0.5,width=width,height=height,text = text,font = 0,color={255,255,255,255},outline = 1,usebox = 1,boxcolor={255,255,255,255} }
		if not Draw3DTexts[handle].show then 
			Tasksync.createloop(Draw3DTexts[handle].actionname,0,function()
				local entity = Draw3DTexts[handle].attachentity
				if entity and DoesEntityExist(entity) then 
					Draw3DTexts[handle].coords = GetOffsetFromEntityInWorldCoords(entity ,offsetX ,offsetY ,offsetZ )
					if #(GetEntityCoords(PlayerPedId()) - Draw3DTexts[handle].coords) < Draw3DTexts[handle].drawdistance then 
						if not font then font = 0 end
						local scale = 1.0
						local height = GetRenderedCharacterHeight(Draw3DTexts[handle].textsizeY,0)
						DrawText3D(Draw3DTexts[handle].coords, Draw3DTexts[handle].text, Draw3DTexts[handle].textsizeX*scale,Draw3DTexts[handle].textsizeY*scale,Draw3DTexts[handle].width*scale,Draw3DTexts[handle].height*scale,Draw3DTexts[handle].font,Draw3DTexts[handle].color,Draw3DTexts[handle].outline,Draw3DTexts[handle].usebox,Draw3DTexts[handle].boxcolor)	
						Draw3DTexts[handle].show = true 
					end 
				else  
					local camCoords = GetGameplayCamCoords()
					local distance = #(coords - camCoords)
					if not font then font = 0 end
					local scale = (1 / distance) * 2
					local fov = (1 / GetGameplayCamFov()) * 100
					scale = scale * fov
					local height = GetRenderedCharacterHeight(Draw3DTexts[handle].textsizeY,0)
					
					DrawText3D(Draw3DTexts[handle].coords, Draw3DTexts[handle].text, Draw3DTexts[handle].textsizeX*scale,Draw3DTexts[handle].textsizeY*scale,Draw3DTexts[handle].width*scale,Draw3DTexts[handle].height*scale,Draw3DTexts[handle].font,Draw3DTexts[handle].color,Draw3DTexts[handle].outline,Draw3DTexts[handle].usebox,Draw3DTexts[handle].boxcolor)	
					Draw3DTexts[handle].show = true 
				end
			end)
		end 
		return handle
	end 
	Update3DTextLabelColor = function(handle,color) -- 0xff0000ff
		Draw3DTexts[handle].color = NB.Utils.Colour.HexToRGBA(color,true) 
	end 
	Update3DTextLabelFont = function(handle,font)
		Draw3DTexts[handle].font = font
	end 
	Update3DTextLabelSetOutline = function(handle,isoutline)
		Draw3DTexts[handle].outline = isoutline and 1 or 0
	end 
	Update3DTextLabelUseBox = function(handle,isusebox)
		Draw3DTexts[handle].usebox = isusebox and 1 or 0
	end 
	Update3DTextLabelTextSize = function(handle,textsizeX,textsizeY) 
		Draw3DTexts[handle].textsizeX = textsizeX
		Draw3DTexts[handle].textsizeY = textsizeY
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(Draw3DTexts[handle].text)
		width = EndTextCommandGetWidth(1)
		Draw3DTexts[handle].width = width
		Draw3DTexts[handle].height = GetRenderedCharacterHeight(textsizeY,0)
	end 
	Update3DTextLabelBoxColor = function(handle,boxcolor) -- 0xff0000ff
		Draw3DTexts[handle].boxcolor = NB.Utils.Colour.HexToRGBA(boxcolor,true)
	end 
	Update3DTextLabelSetString = function(handle,text)
		Draw3DTexts[handle].text = text
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(Draw3DTexts[handle].text)
		width = EndTextCommandGetWidth(1)
		Draw3DTexts[handle].width = width
		Draw3DTexts[handle].height = GetRenderedCharacterHeight(Draw3DTexts[handle].textsizeY,0)
	end 
	Attach3DTextLabelToEntity = function(handle,entity,offsetX,offsetY,offsetZ)
		Draw3DTexts[handle].attachentity = entity

	end 
	Attach3DTextLabelToPlayer = function(handle,playerid,...)
		return Attach3DTextLabelToEntity(handle,GetPlayerPed(playerid),...)
	end 
	Attach3DTextLabelToPed = Attach3DTextLabelToEntity
	Attach3DTextLabelToVehicle = Attach3DTextLabelToEntity
	Attach3DTextLabelToObject = Attach3DTextLabelToEntity
	
	local TextDraws = {}
	local TextDrawsIndex = 0
	local DrawText2D = function(text,x,y,textsizeX,textsizeY,width,height,font,color,outline,usebox,boxcolor)
		SetScriptGfxDrawOrder(1)
		SetTextScale(textsizeX, textsizeY)
		SetTextFont(font)
		SetTextColour(table.unpack(color))
		if outline > 0  then 
			SetTextOutline()
		end 
		SetTextCentre(true)
		BeginTextCommandDisplayText('STRING')
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandDisplayText(x, y)
		if usebox > 0  then 
			SetScriptGfxDrawOrder(0)
			DrawRect(x, y+height/2+height/4,width,height,table.unpack(boxcolor))
		end 
		ClearDrawOrigin()
	end
	TextDrawDestroy = function(handle)
		Tasksync.deleteloop(TextDraws[handle].actionname)
		TextDraws[handle] = nil
	end 
	TextDrawCreate = function(xper,yper,text)
		TextDrawsIndex = TextDrawsIndex + 1
		local handle = TextDrawsIndex
		local actionname = "TextDrawsIndex"..TextDrawsIndex
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(text)
		width = EndTextCommandGetWidth(1)
		local height = GetRenderedCharacterHeight(0.5,0)
		TextDraws[handle] = {actionname =  actionname,x = xper,y = yper,textsizeX=0.5,textsizeY=0.5,width=width,height=height,text = text,font = 0,color={255,255,255,255},outline = 1,usebox = 1,boxcolor={255,255,255,255} }
		return handle 
	end 
	TextDrawShow = function(handle)
		if TextDraws[handle].hide then 
			TextDraws[handle].hide = nil
		end 	
		if not TextDraws[handle].show then 
			Tasksync.createloop(TextDraws[handle].actionname,0,function()
				if not TextDraws[handle].hide then 
					TextDraws[handle].show = true 
					DrawText2D(TextDraws[handle].text,TextDraws[handle].x,TextDraws[handle].y,TextDraws[handle].textsizeX,TextDraws[handle].textsizeY,TextDraws[handle].width,TextDraws[handle].height,TextDraws[handle].font,TextDraws[handle].color,TextDraws[handle].outline,TextDraws[handle].usebox,TextDraws[handle].boxcolor)
				end 
			end)
		end 
	end 
	TextDrawHide = function(handle,color)
		TextDraws[handle].hide = true
	end 
	TextDrawColor = function(handle,color) -- 0xff0000ff
		TextDraws[handle].color = NB.Utils.Colour.HexToRGBA(color,true) 
	end 
	TextDrawFont = function(handle,font)
		TextDraws[handle].font = font
	end 
	TextDrawSetOutline = function(handle,isoutline)
		TextDraws[handle].outline = isoutline and 1 or 0
	end 
	TextDrawUseBox = function(handle,isusebox)
		TextDraws[handle].usebox = isusebox and 1 or 0
	end 
	TextDrawTextSize = function(handle,textsizeX,textsizeY) 
		TextDraws[handle].textsizeX = textsizeX
		TextDraws[handle].textsizeY = textsizeY
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(TextDraws[handle].text)
		width = EndTextCommandGetWidth(1)
		TextDraws[handle].width = width
		TextDraws[handle].height = GetRenderedCharacterHeight(textsizeY,0)
	end 
	TextDrawBoxColor = function(handle,boxcolor) -- 0xff0000ff
		TextDraws[handle].boxcolor = NB.Utils.Colour.HexToRGBA(boxcolor,true)
	end 
	TextDrawSetString = function(handle,text)
		TextDraws[handle].text = text
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(TextDraws[handle].text)
		width = EndTextCommandGetWidth(1)
		TextDraws[handle].width = width
		TextDraws[handle].height = GetRenderedCharacterHeight(TextDraws[handle].textsizeY,0)
	end 
