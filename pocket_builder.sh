#!/bin/bash
# PocketCHIP Setup Script

BROWSER="dwb"
REPO="https://raw.githubusercontent.com/napear/chipbuild/master"

echo -e "[*] Setting new user password\nDefault password is 'chip'"
passwd

echo -e "[*] Setting new admin password\nDefault password is 'chip"
sudo passwd

echo "[*] updating package manager"
sudo apt-get update 

echo "[*] installing software packages"
sudo apt-get -y install openssh-client openssh-server irssi lynx cowsay\
                        $BROWSER build-essential ruby ruby-dev

sudo gem install pry

# Remove some pre-installed browser
sudo apt-get remove surf

# Disable the SSH service on start up.
sudo systemctl disable ssh 
sudo systemctl stop ssh


if [ "$BROWSER" == "dwb" ];then
    echo "[*] Configuring dwb browser"
	if [ ! -d "$HOME/.config/dwb" ];then
		mkdir -p $HOME/.config/dwb
	fi

# Download the dwb config file
	wget -qO ~/.config/dwb/settings $REPO/configs/dwb-settings
fi

echo "[*] Creating new aliases"
wget -qO ~/.bash_aliases $REPO/configs/aliases
source ~/.bashrc


echo '[*] Replacing the default pocket-home config'
# Create backup of original config
if [ ! -f /usr/share/pocket-home/config.json.bak ];then
	sudo mv /usr/share/pocket-home/config.json{,.bak}
fi
sudo wget -qO /usr/share/pocket-home/config.json $REPO/configs/pocket-home-template.json

sudo sed -i "s/BROWSER_EXEC/${BROWSER}/g" /usr/share/pocket-home/config.json

# Reload home screen
sudo skill pocket-home

echo ''
echo "╔═╗┬  ┬    ╔╦╗┌─┐┌┐┌┌─┐┬┬"
echo "╠═╣│  │     ║║│ ││││├┤ ││"
echo "╩ ╩┴─┘┴─┘  ═╩╝└─┘┘└┘└─┘oo"
echo -e "\nType \"exit\" and restart the terminal."