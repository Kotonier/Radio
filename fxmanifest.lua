fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Kotonier'
version '1.0.0'

shared_script "fixDeleteVehicle.lua"
shared_scripts {
    '@ox_lib/init.lua', 
    '@es_extended/imports.lua',
}

client_scripts {
    'client/**.lua',
}

dependencies {
    'ox_lib'
}

