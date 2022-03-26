lua54 'yes'
fx_version 'adamant'
game 'gta5'

shared_scripts {
    "config.lua"
}

client_scripts {
    -- RageUI
    "libs/RMenu.lua",
    "libs/menu/RageUI.lua",
    "libs/menu/Menu.lua",
    "libs/menu/MenuController.lua",
    "libs/components/*.lua",
    "libs/menu/elements/*.lua",
    "libs/menu/items/*.lua",
    "libs/menu/panels/*.lua",
    "libs/menu/windows/*.lua",
    -- Client
    "client/*.lua",
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "server/*.lua"
}

--- Xed#1188