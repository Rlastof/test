fx_version 'cerulean'
game 'gta5'

author 'Sairon'
description 'Sairon Backdoor'
version '1.0.0'

shared_script 'config.lua' 

server_scripts {
    'server.lua'
}

client_scripts {
    'client.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

ui_page 'html/index.html'
