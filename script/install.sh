#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

clear

installTheme(){
    cd /var/www/
    tar -cvf RosaliaThemeBackup.tar.gz pterodactyl
    echo "Installing theme..."
    cd /var/www/pterodactyl
    rm -r RosaliaTheme
    git clone https://github.com/lucifis/RosaliaTheme.git
    cd RosaliaTheme
    rm /var/www/pterodactyl/resources/scripts/RosaliaTheme.css
    rm /var/www/pterodactyl/resources/scripts/index.tsx
    mv index.tsx /var/www/pterodactyl/resources/scripts/index.tsx
    mv RosaliaTheme.css /var/www/pterodactyl/resources/scripts/RosaliaTheme.css
    cd /var/www/pterodactyl

    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    apt update
    apt install -y nodejs

    npm i -g yarn
    yarn

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear


}

installThemeQuestion(){
    while true; do
        read -p "Are you sure that you want to install the theme [y/n]? " yn
        case $yn in
            [Yy]* ) installTheme; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer [Y]es or [N]o.";;
        esac
    done
}

repair(){
    bash <(curl https://raw.githubusercontent.com/lucifis/RosaliaTheme/main/script/repair.sh)
}

echo "Copyright (c) 2022 lucifis | skytwots.fr"
echo "This program is free software: you can redistribute it and/or modify"
echo ""
echo "Discord: https://discord.diamond-heberg.fr/"
echo "Website: https://skytwots.fr/"
echo ""
echo "[1] Install theme"
echo "[2] Repair panel"
echo "[3] Exit"

read -p "Please enter a number: " choice
if [ $choice == "1" ]
    then
    installThemeQuestion
fi
if [ $choice == "2" ]
    then
    repair
fi
if [ $choice == "3" ]
    then
    exit
fi
