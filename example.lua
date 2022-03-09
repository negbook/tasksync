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
    },
    cbs = {
        {"UP","JUST_RELEASED",function(...) print('cb:',...) end , "fuck"},
        {"UP","JUST_PRESSED",function(...) print('cb:',...) end , "fuck"},
        {"RIGHT","JUST_PRESSED",function(...) print('cb:',...) end , "fuck"},
        
        {"RIGHT","JUST_HOLDED",function(...) print('cb:',...) end , "fuck"},
        {"RIGHT","PRESSED",function(...) print('cb:',...) end , "fuck"},
        {"RIGHT","JUST_RELEASED",function(...) print('cb:',...) end , "fuck"},
        {"DOWN","JUST_RELEASED",function(...) print('cb:',...) end , "fuck"},
        {{"Q","E","W"},"JUST_PRESSED",function(...) print('cb:',...) end , "fuck"},
        {{"Q","E","W"},"JUST_HOLDED",function(...) print('cb:',...) end , "fuck"},
        {{"Q","E","W"},"PRESSED",function(...) print('cb:',...) end , "fuck"},
        {{"Q","E","W"},"JUST_RELEASED",function(...) print('cb:',...) end , "fuck"},
    }
})
Tasksync.KeyContainer.RegisterEntry("test2")

Tasksync.KeyContainer.SetGroupNamespaceActive("test","test_keys",true)

--[[
local a = function(duration)
    print(duration("get"))
    if duration("get") > 1000 then 
        duration("break")
    end 
    duration("set",math.random(0,2000))
end 
local b = function()
    print("break")
end 
CreateThread(function() while true do Wait(1000)
    local c = Tasksync.looponcenewthread("a",1000,a,b)

    local d = Tasksync.looponcenewthread("a",500,a,b)

end end )
--]]