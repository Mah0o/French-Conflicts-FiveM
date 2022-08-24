fx_version 'adamant'

game 'gta5'

description 'ESX core'

version 'legacy'

shared_script '@es_extended/imports.lua'

lua54 'yes'

server_scripts {
    '@es_extended/locale.lua',
    '@oxmysql/lib/MySQL.lua',
    '@async/async.lua',
    'esx_basicneeds/locales/fr.lua',
    'esx_basicneeds/config.lua',
    'esx_basicneeds/server/main.lua',
	'esx_billing/locales/*.lua',
	'esx_billing/config.lua',
	'esx_billing/server/main.lua',
	'esx_compact/service/server.lua',
	'esx_compact/license/server.lua',
	'esx_compact/datastore/classes/datastore.lua',
	'esx_compact/datastore/main.lua',
	'esx_compact/addoninventory/classes/addoninventory.lua',
	'esx_compact/addoninventory/main.lua',
	'esx_compact/addonaccount/classes/addonaccount.lua',
	'esx_compact/addonaccount/main.lua',
    'esx_skin/locales/de.lua',
	'esx_skin/locales/br.lua',
	'esx_skin/locales/en.lua',
	'esx_skin/locales/fi.lua',
	'esx_skin/locales/fr.lua',
	'esx_skin/locales/sv.lua',
	'esx_skin/locales/pl.lua',
	'esx_skin/locales/es.lua',
	'esx_skin/locales/tr.lua',
	'esx_skin/config.lua',
	'esx_skin/server/main.lua',
    'esx_society/locales/*.lua',
    'esx_society/config.lua',
    'esx_society/server/main.lua',
    'esx_status/config.lua',
	'esx_status/server/main.lua',
    'esx_menu_dialog/html/ui.html',

	'esx_menu_dialog/html/css/app.css',

	'esx_menu_dialog/html/js/mustache.min.js',
	'esx_menu_dialog/html/js/app.js',

	'esx_menu_dialog/html/fonts/pdown.ttf',
	'esx_menu_dialog/html/fonts/bankgothic.ttf',
    'instance/locales/fr.lua',
	'instance/config.lua',
	'instance/server/main.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    '@es_extended/client/wrapper.lua',
    'esx_basicneeds/locales/fr.lua',
    'esx_basicneeds/config.lua',
    'esx_basicneeds/client/main.lua',
	'esx_billing/locales/*.lua',
	'esx_billing/config.lua',
	'esx_billing/client/main.lua',
    'esx_compact/service/client.lua',
	'esx_compact/scripts/client.lua',
    'esx_skin/locales/de.lua',
	'esx_skin/locales/br.lua',
	'esx_skin/locales/en.lua',
	'esx_skin/locales/fi.lua',
	'esx_skin/locales/fr.lua',
	'esx_skin/locales/sv.lua',
	'esx_skin/locales/pl.lua',
	'esx_skin/locales/es.lua',
	'esx_skin/locales/tr.lua',
	'esx_skin/config.lua',
	'esx_skin/client/main.lua',
    'esx_society/locales/*.lua',
    'esx_society/config.lua',
    'esx_society/client/main.lua',
    'esx_menu_default/client/main.lua',
    'esx_status/config.lua',
	'esx_status/client/classes/status.lua',
    'esx_status/client/main.lua',
    'esx_menu_dialog/client/main.lua',
    'esx_menu_list/client/main.lua',
    'skinchanger/locale.lua',
	'skinchanger/locales/fr.lua',
	'skinchanger/config.lua',
	'skinchanger/client/main.lua',
    'instance/locales/fr.lua',
	'instance/config.lua',
	'instance/client/main.lua'
}

ui_page {
    'esx_status/html/ui.html',
}


files {
	'esx_status/html/ui.html',
	'esx_status/html/css/app.css',
	'esx_status/html/scripts/app.js',
        'esx_menu_default/html/ui.html',
        'esx_menu_default/html/css/app.css',
        'esx_menu_default/html/js/mustache.min.js',
        'esx_menu_default/html/js/app.js',
        'esx_menu_default/html/fonts/pdown.ttf',
        'esx_menu_default/html/fonts/bankgothic.ttf',
        'esx_menu_default/html/fonts/v.ttf',
        'esx_menu_default/html/img/cursor.png',
        'esx_menu_default/html/img/keys/enter.png',
        'esx_menu_default/html/img/keys/return.png',
        'esx_menu_default/html/img/header/247.png',
        'esx_menu_default/html/img/header/tatoo.png',
        'esx_menu_default/html/img/header/Inventaire.jpg',
        'esx_menu_default/html/img/header/Accessoires.png',
        'esx_menu_default/html/img/header/actions_metier.jpg',
        'esx_menu_default/html/img/header/ammunation.jpg',
        'esx_menu_default/html/img/header/animations.jpg',
        'esx_menu_default/html/img/header/armesillegales.jpg',
        'esx_menu_default/html/img/header/autoecole.jpg',
        'esx_menu_default/html/img/header/changer.png',
        'esx_menu_default/html/img/header/Concessionnaire.jpg',
        'esx_menu_default/html/img/header/Entreprise.png',
        'esx_menu_default/html/img/header/factures.jpg',
        'esx_menu_default/html/img/header/fourriere.jpg',
        'esx_menu_default/html/img/header/garage.jpg',
        'esx_menu_default/html/img/header/gestionpatron.png',
        'esx_menu_default/html/img/header/gpsrapide.jpg',
        'esx_menu_default/html/img/header/identite.png',
        'esx_menu_default/html/img/header/lscus.png',
        'esx_menu_default/html/img/header/masque.jpg',
        'esx_menu_default/html/img/header/Me_concernant.jpg',
        'esx_menu_default/html/img/header/mecano.png',
        'esx_menu_default/html/img/header/menu.jpg',
        'esx_menu_default/html/img/header/moderation.jpg',
        'esx_menu_default/html/img/header/poleemploi.png',
        'esx_menu_default/html/img/header/Quincaillerie.jpg',
        'esx_menu_default/html/img/header/skin_menu.png',
        'esx_menu_default/html/img/header/suburban.png',
        'esx_menu_default/html/img/header/universite.jpg',
        'esx_menu_default/html/img/header/valider.png',
        'esx_menu_default/html/img/header/vehicle.png',
        'esx_menu_default/html/img/header/vestiaire.jpg',
        'esx_menu_list/html/ui.html',

	'esx_menu_list/html/css/app.css',

	'esx_menu_list/html/js/mustache.min.js',
	'esx_menu_list/html/js/app.js',

	'esx_menu_list/html/fonts/pdown.ttf',
	'esx_menu_list/html/fonts/bankgothic.ttf'
}


dependencies {
    'es_extended',
   -- 'esx_status',
    'skinchanger',
    'cron',
 'esxCore',
}

dependency {'es_extended',
'esxCore'
}