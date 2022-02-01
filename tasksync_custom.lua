--
if not Tasksync then 
	Tasksync = setmetatable({},{})
end 
Tasksync.tasksjob_custom = {}
Tasksync.taskstodo_custom = {}
Tasksync.taskstodo_custom_newduration = {}
Tasksync.set_custom_duration = function(customgroup,newduration)
	Tasksync.taskstodo_custom_newduration[customgroup] = newduration
end 
Tasksync.get_custom_duration = function(customgroup)
	return Tasksync.taskstodo_custom_newduration[customgroup]
end 
Tasksync.__createbytemplate_custom = function(customgroup,defaultduration)
	CreateThread(function()
		local todo = Tasksync.taskstodo_custom
		local jobname = customgroup
		local delaySetter = {setter=setmetatable({},{__call = function(t,newduration) Tasksync.set_custom_duration(customgroup,newduration) end}),getter=function(t,newduration) return Tasksync.get_custom_duration(customgroup) end}
		local fn = todo[jobname]
		repeat
			if fn then fn(delaySetter) end 
			Wait(Tasksync.taskstodo_custom_newduration[customgroup])
		until not todo[customgroup] 
		--print('breaked2')
		return 
	end)
end 	
Tasksync.addloopcustom = function(customgroup,defaultduration,fn) --jobname,duration,function
	if Tasksync.taskstodo_custom[customgroup] ~= nil then error('Duplicated taskjob: '..jobname, 2) ; return end 
	Tasksync.taskstodo_custom[customgroup] = fn 
	Tasksync.taskstodo_custom_newduration[customgroup] = defaultduration
	Tasksync.__createbytemplate_custom(customgroup,defaultduration)
end 
Tasksync.deleteloopcustom = function(customgroup)
	Tasksync.taskstodo_custom[customgroup] = nil
end 
