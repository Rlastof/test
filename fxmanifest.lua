fx_version 'cerulean'
game 'gta5'

name 'Backdoor Scanner'
author 'SaironV'
description 'A tool for scanning and managing scripts in FiveM'
version '1.0.0'

client_scripts {
    'config.lua',
    'client.lua'
}

server_script 'server.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}
