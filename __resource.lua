description 'Fivem-WarnScript'

version '1.0'

client_script "client.lua"

server_scripts {

    'server.lua',
	'@mysql-async/lib/MySQL.lua',
	'version.lua'

}