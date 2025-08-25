fx_version 'cerulean'
game 'gta5'

author 'Dead Scripts'
description 'PoliceEMSActivity'
version '1.0'
url ''

client_scripts {
	'client.lua',
    'EmergencyBlips/cl_emergencyblips.lua',
}

server_scripts {
	'config.lua',
	"server.lua",
    'EmergencyBlips/sv_emergencyblips.lua',
}
