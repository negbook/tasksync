--
if not Tasksync then 
	Tasksync = setmetatable({},{})
end 

Tasksync.tasksjob = {}
Tasksync.taskstodo = {}
Tasksync.__createbytemplate = function(durationgroup)
	CreateThread(function()
		repeat
			local jobs = Tasksync.tasksjob
			local tasks = jobs[durationgroup]
			local todo = Tasksync.taskstodo
			if tasks then 
				for i=1,#tasks do 
					local jobname = tasks[i]
					if todo[jobname] then todo[jobname]() end 
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

Tasksync._scaleformHandle = {}
Tasksync._scaleformHandleDrawing = {}
Tasksync._scaleformInfo = {}

Tasksync._loadscaleform = function(scaleformName,cb)
	local scaleformHandle = RequestScaleformMovie(scaleformName)
	while not HasScaleformMovieLoaded(scaleformHandle) do
		Citizen.Wait(0)
	end
	Tasksync._scaleformHandle[scaleformName] = scaleformHandle
	Tasksync._sendscaleformvalues = function (...)
		local tb = {...}
		PushScaleformMovieFunction(Tasksync._scaleformHandle[scaleformName],tb[1])
		for i=2,#tb do
			if type(tb[i]) == "number" then 
				if math.type(tb[i]) == "integer" then
						ScaleformMovieMethodAddParamInt(tb[i])
				else
						ScaleformMovieMethodAddParamFloat(tb[i])
				end
			elseif type(tb[i]) == "string" then ScaleformMovieMethodAddParamTextureNameString(tb[i])
			elseif type(tb[i]) == "boolean" then ScaleformMovieMethodAddParamBool(tb[i])
			end
		end 
		PopScaleformMovieFunctionVoid()
	end
	if cb then 
		cb(Tasksync._sendscaleformvalues)
	end 
end

Tasksync.ScaleformDraw = function(scaleformName,cb,layer, x ,y ,width ,height ,red ,green ,blue ,alpha ,unk) 
	if not Tasksync._scaleformHandleDrawing[scaleformName] then 
		Tasksync._loadscaleform(scaleformName,cb)
		if Tasksync._scaleformHandle[scaleformName] then 
			Tasksync._scaleformHandleDrawing[scaleformName] = true  
			Tasksync.addloop('scaleforms:draw:'..scaleformName,0,function()
				if Tasksync._scaleformHandle[scaleformName] then 
					if layer then SetScriptGfxDrawOrder(layer) end 
					DrawScaleformMovieFullscreen(Tasksync._scaleformHandle[scaleformName])
					if layer then ResetScriptGfxAlign() end
				else 
					Tasksync.deleteloop('scaleforms:draw:'..scaleformName)
					Tasksync._scaleformHandleDrawing[scaleformName] = false 
				end 
			end)
		end 
	else 
		error("Duplicated Drawing Scaleform",2)
	end 
end 

Tasksync.ScaleformDrawMini = function(scaleformName, x ,y ,width ,height ,red ,green ,blue ,alpha ,unk, cb,layer) 
	if not Tasksync._scaleformHandleDrawing[scaleformName] then 
		Tasksync._loadscaleform(scaleformName,cb)
		if Tasksync._scaleformHandle[scaleformName] then 
			Tasksync._scaleformHandleDrawing[scaleformName] = true  
			Tasksync.addloop('scaleforms:draw:'..scaleformName,0,function()
				if Tasksync._scaleformHandle[scaleformName] then 
					if layer then SetScriptGfxDrawOrder(layer) end 
					DrawScaleformMovie(Tasksync._scaleformHandle[scaleformName] ,x ,y ,width ,height ,red ,green ,blue ,alpha ,unk )
					if layer then ResetScriptGfxAlign() end
				else 
					Tasksync.deleteloop('scaleforms:draw:'..scaleformName)
					Tasksync._scaleformHandleDrawing[scaleformName] = false 
				end 
			end)
		end
	else 
		error("Duplicated Drawing Scaleform",2)
	end 
end 

Tasksync.ScaleformCall = function(scaleformName,cb) 
	if not cb then error("What is you want to call?",2) end 
	Tasksync._loadscaleform(scaleformName,cb)
end 

Tasksync.ScaleformEnd = function(scaleformName,cb) 
	SetScaleformMovieAsNoLongerNeeded(Tasksync._scaleformHandle[scaleformName])
	Tasksync._scaleformHandle[scaleformName] = nil 
end 

