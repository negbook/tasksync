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
			for i=1,#tasks do 
				local jobname = tasks[i]
				if todo[jobname] then todo[jobname]() end 
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
