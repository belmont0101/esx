fx_version 'adamant'

game 'gta5'
lua54 'yes'
description 'Allows players to harvest and sell marijuana - ox_lib version'
version '2.0.0'
legacyversion '1.13.4'

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client/main.lua',
	'client/weed.lua'
}

dependencies {
	'es_extended',
	'ox_lib',
	'ox_target'
}
