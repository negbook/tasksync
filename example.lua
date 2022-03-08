load(LoadResourceFile("tasksync", 'tasksync.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_once.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_with_scaleform.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_with_keycontainer.lua.sourcecode'))()


Tasksync.KeyContainer.Create("test","test_keys",{
    keys = {
        {"UP","keyboard"},
        {"DOWN"}
    },
    cbs = {
        {"UP","JUST_RELEASED",function(...) print('cb:',...) end , "fuck"},
        {"UP","JUST_PRESSED",function(...) print('cb:',...) end , "fuck"},
        {"RIGHT","PRESSED",function(...) print('cb:',...) end , "fuck"},
        {"DOWN","JUST_RELEASED",function(...) print('cb:',...) end , "fuck"}
    }
})
Tasksync.KeyContainer.RegisterEntry("test2")
Tasksync.KeyContainer.Create("test2","test2_keys",{
    keys = {
        {"RIGHT","keyboard"},
        {"DOWN"}
    },
    cbs = {
        {"RIGHT","JUST_RELEASED",function(...) print('cb2:',...) end , "fuck"},
        {"RIGHT","PRESSED",function(...) print('cb2:',...) end , "fuck"},
        {"DOWN","JUST_RELEASED",function(...) print('cb2:',...) end , "fuck"}
    }
})
