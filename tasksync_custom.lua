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
		repeat
			local todo = Tasksync.taskstodo_custom
			local jobname = customgroup
			local predelaySetter = {setter=setmetatable({},{__call = function(t,newduration) Tasksync.set_custom_duration(customgroup,newduration) end}),getter=function(t,newduration) return Tasksync.get_custom_duration(customgroup) end}
            local delaySetter = predelaySetter
			if todo[jobname] then todo[jobname](delaySetter) end 
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
Tasksync.removeloopcustom = function(customgroup)
	Tasksync.taskstodo_custom[customgroup] = nil
end 
Tasksync.deleteloopcustom = Tasksync.removeloopcustom
