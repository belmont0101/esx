fx_version 'cerulean'
game 'gta5'

author 'Belmont Development'
description 'Illegal Jobs System for ESX using ox_inventory, ox_lib, and ox_target'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

dependencies {
    'es_extended',
    'ox_inventory',
    'ox_lib',
    'ox_target'
}

lua54 'yes'
