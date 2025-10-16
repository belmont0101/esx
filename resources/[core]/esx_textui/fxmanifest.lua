fx_version 'adamant'

game 'gta5'
author 'ESX-Framework'
description 'A beautiful and simple Persistent Notification system for ESX using ox_lib'
version '2.0.0'
lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua'
}

client_scripts { 'TextUI.lua' }
