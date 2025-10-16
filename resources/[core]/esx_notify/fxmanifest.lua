fx_version 'adamant'

lua54 'yes'
game 'gta5'
version '2.0.0'
author 'ESX-Framework'
description 'A beautiful and simple NUI notification system for ESX using ox_lib'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua'
}

client_scripts { 'Config.lua', 'Notify.lua'}
