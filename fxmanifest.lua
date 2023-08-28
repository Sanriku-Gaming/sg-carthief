fx_version "cerulean"
game "gta5"

name "Car Thief"
author "Nicky"
description 'Search Cars for Items'
version '1.0.0'

shared_scripts {
	'config.lua'
}

client_scripts{
    'client/client.lua'
}

server_scripts{
    '@mysql-async/lib/MySQL.lua',
    'server/server.lua'
}

lua54 'yes'