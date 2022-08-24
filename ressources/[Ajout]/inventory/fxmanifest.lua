fx_version 'adamant'
games {'gta5'}

client_scripts {
  "utils.lua",
  "menu.lua",
  "inventaire/client/*.lua",
  "weaponitem/client/*.lua",
  "clotheshop/client/*.lua"
}

server_scripts {
  "@mysql-async/lib/MySQL.lua",
  "inventaire/server/*.lua",
  "weaponitem/server/*.lua",
  "clotheshop/server/*.lua"
}

shared_scripts {
  "shared/shared.lua"
}

ui_page 'inventaire/html/ui.html'

files {
  'inventaire/html/*.html',
  'inventaire/html/js/*.js',
  'inventaire/html/css/*.css',
  'inventaire/html/locales/*.js',
  'inventaire/html/img/hud/*.png',
  'inventaire/html/img/*.png',
  'inventaire/html/img/items/*.png',
}
