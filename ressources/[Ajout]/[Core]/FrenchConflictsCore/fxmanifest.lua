fx_version 'adamant'
game 'gta5'

shared_scripts {
     "config.lua",
 }

client_scripts {
     "client/*.lua",
}

server_scripts {
     '@oxmysql/lib/MySQL.lua',
     "server/*.lua",
}

exports {
     "GetFuel",
     "SetFuel"
}