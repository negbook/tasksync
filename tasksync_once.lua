--
if not Tasksync then 
	Tasksync = setmetatable({},{})
end
Tasksync.tasksjob_once = {}
Tasksync.taskstodo_once = {}
Tasksync.__createbytemplate_once = function(durationgroup)
	CreateThread(function()
		repeat 
			local jobs_once = Tasksync.tasksjob_once
			local tasks_once = jobs_once[durationgroup]
			local todo = Tasksync.taskstodo_once
			for i=1,#tasks_once do 
				local jobname = tasks_once[i]
				if todo[jobname] then todo[jobname]() end 
			end 
			Wait(durationgroup)
		until not tasks_once 
		--print('breaked2')
		return 
	end)
end 	
Tasksync.addlooponce = function(jobname,durationgroup,fn) --jobname,duration,function
	--if Tasksync.taskstodo[jobname] ~= nil then error('Duplicated taskjob: '..jobname, 2) ; return end 
	local creatable = false 
	local found = false 
	if Tasksync.tasksjob_once[durationgroup] and #Tasksync.tasksjob_once[durationgroup] > 0 then 
		for i=1,#Tasksync.tasksjob_once[durationgroup] do 
			if Tasksync.tasksjob_once[durationgroup][i] == jobname then 
				found = true 
			end 
		end 
	end 
	if not found then 
		Tasksync.taskstodo_once[jobname] = fn
		if Tasksync.tasksjob_once[durationgroup] == nil then creatable = true; Tasksync.tasksjob_once[durationgroup] = {}; end 
		table.insert(Tasksync.tasksjob_once[durationgroup],jobname)
		if creatable then 
			Tasksync.__createbytemplate_once(durationgroup)
		end 
	end 
end 
Tasksync.deletelooponce = function(jobname)
	for durationgroup,v in pairs(Tasksync.tasksjob_once) do 
		for i=1,#Tasksync.tasksjob_once[durationgroup] do 
			if Tasksync.tasksjob_once[durationgroup][i] == jobname then 
				Tasksync.taskstodo_once[jobname] = nil 
				table.remove(Tasksync.tasksjob_once[durationgroup],i)
				if #Tasksync.tasksjob_once[durationgroup] == 0 then 
					Tasksync.tasksjob_once[durationgroup] = nil
				end 
			end 
		end 
	end 
end 

