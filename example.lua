load(LoadResourceFile("tasksync", 'tasksync.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_once.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_with_scaleform.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_with_keycontainer.lua.sourcecode'))()

Tasksync.KeyContainer.RegisterEntry("test")
Tasksync.KeyContainer.Create("test","test_keys",{
    keys = {
        {"UP","keyboard"},
        {"RIGHT"},
        {"DOWN"},
        {{"Q","E","W"}},
        {{"E","R","D","F"}},
    },
    cbs = {
        {"UP","JUST_RELEASED",function(...) print('cb:',...) end , "wtf"},
        {"UP","PRESSED",function(...) print('cb:',...) end , "wtf"},
        {"UP","JUST_PRESSED",function(...) print('cb:',...) end , "wtf"},
        {"RIGHT","JUST_PRESSED",function(...) print('cb:',...) end , "wtf"},
        
        {"RIGHT","JUST_HOLDED",function(...) print('cb:',...) end , "wtf"},
        {"RIGHT","PRESSED",function(...) print('cb:',...) end , "wtf"},
        {"RIGHT","JUST_RELEASED",function(...) print('cb:',...) end , "wtf"},
        {"DOWN","JUST_RELEASED",function(...) print('cb:',...) end , "wtf"},
        {{"E","W"},"JUST_PRESSED",function(k,...) print('cb:',k,...) end , "wtf"},
        {{"E","W"},"JUST_HOLDED",function(k,...) print('cb:',k,...) end , "wtf"},
        {{"E","W"},"PRESSED",function(k,...) print('cb:',k,...) end , "wtf"},
        {{"E","W"},"JUST_RELEASED",function(k,...) print('cb:',k,...) end , "wtf"},
        {{"E","R","D","F"},"JUST_PRESSED",function(k,...) print('cb:',k,...) end , "wtf"},
        {{"E","R","D","F"},"JUST_HOLDED",function(k,...) print('cb:',k,...) end , "wtf"},
        {{"E","R","D","F"},"PRESSED",function(k,...) print('cb:',k,...) end , "wtf"},
        {{"E","R","D","F"},"JUST_RELEASED",function(k,...) print('cb:',k,...) end , "wtf"},
    }
})
Tasksync.KeyContainer.RegisterEntry("test2")
Tasksync.KeyContainer.Create("test2","test_keys2",{
    keys = {
        {"UP","keyboard"},
        {"RIGHT"},
        {"DOWN"},
        {{"E","R"}},
        {{"E","W"}},
        {{"E","R","D","F"}},
    },
    cbs = {
        {"UP","JUST_RELEASED",function(...) print('cb2:',...) end , "wtf"},
        {"UP","JUST_HOLDED",function(...) print('cb2:',...) end , "wtf"},
        {"UP","JUST_PRESSED",function(...) print('cb2:',...) end , "wtf"},
        {"RIGHT","JUST_PRESSED",function(...) print('cb2:',...) end , "wtf"},
        {"RIGHT","JUST_HOLDED",function(...) print('cb2:',...) end , "wtf"},
        {"RIGHT","PRESSED",function(...) print('cb2:',...) end , "wtf"},
        {"RIGHT","JUST_RELEASED",function(...) print('cb2:',...) end , "wtf"},
        {"DOWN","JUST_RELEASED",function(...) print('cb2:',...) end , "wtf"},
        {{"E","W"},"JUST_PRESSED",function(k,...) print('cb2:',k,...) end , "wtf"},
        {{"E","W"},"JUST_HOLDED",function(k,...) print('cb2:',k,...) end , "wtf"},
        {{"E","W"},"PRESSED",function(k,...) print('cb2:',k,...) end , "wtf"},
        {{"E","W"},"JUST_RELEASED",function(k,...) print('cb2:',k,...) end , "wtf"},
        {{"E","R","D","F"},"JUST_PRESSED",function(k,...) print('cb2:',k,...) end , "wtf"},
        {{"E","R","D","F"},"JUST_HOLDED",function(k,...) print('cb2:',k,...) end , "wtf"},
        {{"E","R","D","F"},"PRESSED",function(k,...) print('cb2:',k,...) end , "wtf"},
        {{"E","R","D","F"},"JUST_RELEASED",function(k,...) print('cb2:',k,...) end , "wtf"},
    }
})
Tasksync.KeyContainer.SetGroupNamespaceActive("test","test_keys",true)
Tasksync.KeyContainer.SetGroupNamespaceActive("test2","test_keys2",true)
--[[
local a = function(duration)
    print(duration("get"))
    if duration("get") > 1000 then 
        --duration("break")
        
    end 
    duration("set",math.random(0,2000))
end 
local b = function()
    print("break")
end 
local c
CreateThread(function() while true do Wait(1000)
    c = Tasksync.looponcenewthread("a",1000,a,b)
    
    local d = Tasksync.looponcenewthread("a",500,a,b)

end end )
CreateThread(function()
    Wait(5000)
    local thisduration,thisidx
    c("inserttask",function(duration,idx)
        thisduration,thisidx = duration,idx
        print('cao',duration,idx)
    end)
    Wait(3000)
    if thisduration then thisduration("removetask",thisidx) end
    
end)
--]]