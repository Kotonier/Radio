fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Kotonier'
version '1.0.0'

shared_script "fixDeleteVehicle.lua"
shared_scripts {
    '@ox_lib/init.lua', 
    '@es_extended/imports.lua',
    'config/**.lua',
}

client_scripts {
    'client/**.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/**.lua',
}

files {
    'locales/*.json'
}
dependencies {
    'ox_lib'
}

