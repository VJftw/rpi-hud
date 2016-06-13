#!/bin/bash

# mkdir -p /rpi-hud
# touch /rpi-hud/environment

# echo ""
# echo "Setting up"
# echo ""
# echo "Enter your ForecastIO API Key:"
# read forecastio_key
# echo FORECASTIO_API_KEY=$forecastio_key > /rpi-hud/environment

echo ""
echo "Installing Weston, Midori and NGINX"
echo ""
pacman -Syu weston midori nginx mesa-libgl chromium noto-fonts

echo ""
echo "Setting up NGINX"
echo ""
curl https://raw.githubusercontent.com/VJftw/rpi-hud/develop/rpi-fs/etc/nginx/nginx.conf -o /etc/nginx/nginx.conf
chmod 644 /etc/nginx/nginx.conf
systemctl enable nginx

# echo ""
# echo "Setting up HUD user"
# echo ""
# useradd -d /home/hudapp -m -p hud hudapp
# gpasswd -a hudapp video

echo ""
echo "Installing Automatic Boot files"
echo ""
mkdir -p /hud
curl https://raw.githubusercontent.com/VJftw/rpi-hud/develop/rpi-fs/hud/start_weston.sh > /hud/start_weston.sh
chmod 755 /hud/start_weston.sh

curl https://raw.githubusercontent.com/VJftw/rpi-hud/develop/rpi-fs/etc/systemd/system/hud-weston@.service > /etc/systemd/system/hud-weston@.service
chmod 644 /etc/systemd/system/hud-weston@.service
systemctl daemon-reload
systemctl enable hud-weston@tty2

curl https://raw.githubusercontent.com/VJftw/rpi-hud/develop/rpi-fs/hud/weston.ini > /hud/weston.ini
chmod 644 /hud/weston.ini

echo ""
echo "Fetching Updater"
echo ""
curl -L https://github.com/VJftw/rpi-hud/releases/download/0.0.0/updater-armhf > /hud/updater
chmod 755 /hud/updater

echo ""
echo "Updating"
echo ""
mkdir -p /hud/web
mkdir -p /hud/api
/hud/updater
