if not Tasksync then 
	Tasksync = {}
end
local Loops = {}
local Fn = {}
local FnOnDelete = {}
local FnCustomDurations = {}
setmetatable(Loops,{__mode = "k"})
setmetatable(Fn,{__mode = "k"})
setmetatable(FnOnDelete,{__mode = "k"})
setmetatable(FnCustomDurations,{__mode = "k"})
local GetDurationStringAndIndexFromLoopsIfFnNameExisted = function(_fnname)
    for existeddurationStr,names in pairs(Loops) do 
        for i=1,#names do 
            local v = names[i]
            if v == _fnname then 
                return existeddurationStr,i
            end 
        end 
    end 
end 

local removeFnNameFromDurationGroup = function(_durationStr,idx)
    table.remove(Loops[_durationStr],idx) 
    if #Loops[_durationStr] == 0 then 
        Loops[_durationStr] = nil
    end 
    
end 

local DeleteExistedFnNameIfDurationBecomeDiff = function(_fnname,_durationStr)
    local existeddurationStr,idx = GetDurationStringAndIndexFromLoopsIfFnNameExisted(_fnname)
    if existeddurationStr and _durationStr ~= existeddurationStr then 
        removeFnNameFromDurationGroup(existeddurationStr,idx)
        return true 
    end 
end 


local updateloop = function(_fnname,_newduration)
    local _olddurationStr,idx = GetDurationStringAndIndexFromLoopsIfFnNameExisted(_fnname)
    local _newdurationStr = tostring(_newduration)
    if _olddurationStr ~= _newdurationStr then  
        removeFnNameFromDurationGroup(_olddurationStr,idx)
        if Loops[_newdurationStr] == nil then 
            Loops[_newdurationStr] = {}; 
            -- this is important to wait after just set a new duration  
            Wait(tonumber(_olddurationStr))
            -- Very Important to Wait because CreateThread newduration is diff from oldduration
            Tasksync.__createNewThreadForNewDurationLoopFunctionsGroup(_newdurationStr)
        end 
        table.insert(Loops[_newdurationStr],_fnname)
        return 
    end 
end 

local function newObject(default)
    local value = default or 0
    local haschange = false 
    local haskilled = false 
    return function(action,v) 
        if action == 'get' then 
            if v then 
                local temphaschange = haschange
                local temphaskilled = haskilled
                haschange = false
                haskilled = false
                return value , temphaschange, temphaskilled
            else
                return value  
            end 
        elseif action == 'set' then 
            if value ~= v then 
                haschange = true
                value = v 
            else 
                haschange = false 
            end 
        elseif action == 'kill' or action == 'break' then 
            haskilled = true 
        end 
    end 
end 

Tasksync.__createNewThreadForNewDurationLoopFunctionsGroup = function(_durationStr)
    CreateThread(function()
        local loop = Loops[_durationStr]
        local _durationNum = tonumber(_durationStr)
        local e = {}
        local setgeters = {}
        setmetatable(setgeters,{__mode = "k"})
        repeat  
            local fnList = (loop or e)
            local isAnyJob = fnList[1]
            if isAnyJob then 
                for i=1,#fnList do 
                    local _nowfnname = fnList[i]
                    local f = Fn[_nowfnname]
                    if f then 
                        if setgeters[_nowfnname] == nil then 
                            setgeters[_nowfnname] = newObject(_durationNum) --{isset = false,currentvalue = nil, set= function(self,newduration) self.isset = true;self.currentvalue = newduration end,get= function(self) return Tasksync.getloopcustomduration(_nowfnname) end}
                            
                        end 
                        local duration_editor = setgeters[_nowfnname]
                        f(duration_editor)
                        local durationset,haschange,haskilled = duration_editor('get',true)
                        if haskilled then 
                            setgeters[_nowfnname] = nil
                            Tasksync.deleteloop(_nowfnname)
                        elseif haschange then 
                            setgeters[_nowfnname] = nil
                            Tasksync.setloopcustomduration(_nowfnname,durationset) ;
                        end 
                    end 
                end 
            end 
            Wait(_durationNum)
            
        until not isAnyJob 
        setgeters = nil
        --print("Deleted thread",_durationStr)
        return 
    end)
end     

Tasksync.addloop = function(_fnname,_duration,_fn,_fnondelete,_dontreplace,isonce)
    if isonce then _fnname = _fnname .. "_o_n_c_e_" end

    if Fn[_fnname] ~= nil  then 
        if _dontreplace then return end 
        --print ('Detected Same Name,Replaced loop fn: '.._fnname) ;
        DeleteExistedFnNameIfDurationBecomeDiff(_fnname,nil)
    end
    
    Fn[_fnname] = _fn  
    
    if _fnondelete then 
        FnOnDelete[_fnname] = _fnondelete  
    end 
    
    local _durationStr = tostring(_duration)
    
    if Loops[_durationStr] == nil then 
        Loops[_durationStr] = {}; 
        Tasksync.__createNewThreadForNewDurationLoopFunctionsGroup(_durationStr)
    end 
    table.insert(Loops[_durationStr],_fnname)
    return _fnname
end 
Tasksync.insertloop = Tasksync.addloop

Tasksync.deleteloop = function(_fnname,isonce)
    if isonce then _fnname = _fnname .. "_o_n_c_e_" end
    local durationStr,idx = GetDurationStringAndIndexFromLoopsIfFnNameExisted(_fnname)
    if durationStr then 
        Fn[_fnname] = nil 
        removeFnNameFromDurationGroup(durationStr,idx)
        if FnOnDelete[_fnname] then 
            FnOnDelete[_fnname]() 
            FnOnDelete[_fnname] = nil 
        end 
    end 
end 

Tasksync.isloopalive = function(_fnname,isonce)
    if isonce then _fnname = _fnname .. "_o_n_c_e_" end
    
    local durationStr,idx = GetDurationStringAndIndexFromLoopsIfFnNameExisted(_fnname)
    if durationStr then 
        return true 
    end 
     
    return false 
end 

Tasksync.setloopcustomduration = function(_fnname,_duration)
    
    FnCustomDurations[_fnname] = _duration
    
    updateloop(_fnname,_duration)
end 
Tasksync.getloopcustomduration = function(_fnname)
    return FnCustomDurations[_fnname]
end 
Tasksync.hasloopcustomduration = function(_fnname)
    return FnCustomDurations[_fnname] ~= nil
end 

Tasksync.addlooponce = function(_fnname,_duration,_fn,_fnondelete) return Tasksync.addloop(_fnname,_duration,_fn,_fnondelete,true,true) end 
Tasksync.insertlooponce = Tasksync.addlooponce
Tasksync.deletelooponce = function(_fnname) return Tasksync.deleteloop(_fnname,true) end
Tasksync.isloopaliveonce = function(_fnname) return Tasksync.isloopalive(_fnname,true) end