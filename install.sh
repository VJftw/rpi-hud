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
pacman -Syu weston midori nginx mesa-libgl

echo ""
echo "Setting up NGINX"
echo ""
curl https://raw.githubusercontent.com/VJftw/rpi-hud/develop/rpi-fs/etc/nginx/nginx.conf -o /etc/nginx/nginx.conf
chmod 644 /etc/nginx/nginx.conf
systemctl enable nginx

echo ""
echo "Setting up HUD user"
echo ""
useradd -d /home/hudapp -m -p hud

echo ""
echo "Installing Automatic Boot files"
echo ""
mkdir -p /hud
curl https://raw.githubusercontent.com/VJftw/rpi-hud/develop/rpi-fs/etc/systemd/system/getty@tty1.service.d/override.conf -o /etc/systemd/system/getty@tty1.service.d/override.conf
chmod 644 /etc/systemd/system/getty@tty1.service.d/override.conf


curl https://raw.githubusercontent.com/VJftw/rpi-hud/develop/rpi-fs/home/hudapp/.config/weston.ini -o /home/hudapp/.config/weston.ini
chown hudapp:hudapp /home/hudapp/.config/weston.ini
chmod 644 /home/hudapp/.config/weston.ini

curl https://raw.githubusercontent.com/VJftw/rpi-hud/develop/rpi-fs/home/hudapp/.bash_profile -o /home/hudapp/.bash_profile
chown hudapp:hudapp /home/hudapp/.bash_profile
chmod 755 /home/hudapp/.config/.bash_profile


echo ""
echo "Fetching Updater"
echo ""
curl -L https://github.com/VJftw/rpi-hud/releases/download/0.0.0/updater-armhf -o /hud/updater
chmod 755 /hud/updater

echo ""
echo "Updating"
echo ""
/hud/updater
