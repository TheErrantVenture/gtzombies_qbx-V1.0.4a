fx_version 'cerulean'
game 'gta5'

author 'GTLife Store'
description '[QB] Zombies Project'
version '1.0.4'

dependencies {
    'xsound',
    'PolyZone'
}

shared_scripts {
    'config.lua'
}

server_scripts {
    'server/server.lua',
    'server/lootprops.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/client.lua',
    'client/lootprops.lua',
    'client/zboss.lua'
}

files {
    'sounds/*.ogg'
}
