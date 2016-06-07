#!/bin/bash

mkdir -p /rpi-hud
touch /rpi-hud/environment

echo ""
echo "Setting up"
echo ""
echo "Enter your ForecastIO API Key:"
read forecastio_key
echo FORECASTIO_API_KEY=$forecastio_key > /rpi-hud/environment

# Update repositories
echo ""
echo "Updating Repositories"
echo ""
curl https://raw.githubusercontent.com/VJftw/rpi-hud/develop/rpi-fs/etc/apk/repositories -o /etc/apk/repositories
chmod 644 /etc/apk/repositories
apk update

# Install Firefox Browser
echo ""
echo "Installing Firefox Browser"
echo ""
apk add firefox ttf-freefont

# Install X11 and Openbox
echo ""
echo "Installing X11 Server and Openbox Window Manager"
echo ""
setup-xorg-base
apk add xf86-video-fbdev xf86-input-keyboard dbus openbox
rc-update add dbus

echo 'Section "Module"
    Load "fbdevhw"
    Load "fb"
    Load "shadow"
    Load "shadowfb"
    Load "dbe"
    Load "glx"
    Disable "dri"
EndSection' > /etc/X11/xorg.conf.d/20-modules.conf

echo ""
echo "Installing NGINX"
echo ""
apk add nginx
curl https://raw.githubusercontent.com/VJftw/rpi-hud/develop/rpi-fs/etc/nginx/nginx.conf -o /etc/nginx/nginx.conf
chmod 644 /etc/nginx/nginx.conf
update-rc add nginx boot

# Setup Hud User
echo ""
echo "Setting up HUD user"
echo ""
adduser -h /home/hudapp -D hudapp

# Set up Kiosk mode as per http://blogs.wcode.org/2013/09/howto-boot-your-raspberry-pi-into-a-fullscreen-browser-kiosk/
echo ""
echo "Installing Kiosk Mode Boot files"
echo ""
mkdir -p /hud
curl https://raw.githubusercontent.com/VJftw/rpi-hud/develop/rpi-fs/hud/xinitrc -o /hud/xinitrc
chmod 755 /boot/xinitrc
curl https://raw.githubusercontent.com/VJftw/rpi-hud/develop/rpi-fs/hud/start.sh -o /home/hudapp/start.sh
chmod 755 /home/hudapp/start.sh
chown hudapp:hudapp /home/hudapp/start.sh

echo ""
echo "Fetching latest Frontend"
echo ""
mkdir -p /hud/web
rm -rf /hud/web/*

echo ""
echo "Fetching latest API"
echo ""
mkdir -p /hud/api
rm -rf /hud/api/*

sleep 3;

lbu incude /hud
lbu include /home

lbu ci
