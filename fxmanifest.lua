fx_version 'cerulean'
games {'gta5','rdr3'}
author 'negbook'

lua54 'yes'
escrow_ignore {
	'*.*'
}

files {
	'tasksync.lua.sourcecode',
	'tasksync_once.lua.sourcecode',
	'tasksync_with_scaleform.lua.sourcecode',
	'tasksync_with_keycontainer.lua.sourcecode',

}
client_scripts {
'example.lua'
}

server_scripts {
'versionchecker.lua',
--'example-sv.lua'
}


rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
