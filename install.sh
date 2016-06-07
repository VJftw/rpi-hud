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
apk update

# Install Bash and Font
echo ""
echo "Installing Base deps"
echo ""
apk add bash curl ttf-freefont

# Install Firefox Browser
echo ""
echo "Installing Firfox Browser"
echo ""
apk add firefox

# Install X11 and Matchbox
echo ""
echo "Installing X11 Server and Openbox Window Manager"
echo ""
setup-xorg-base
​apk add xf86-video-fbdev xf86-input-mouse xf86-input-keyboard dbus
rc-update ​​add dbus

echo 'Section "Module"
    Load "fbdevhw"
    Load "fb"
    Load "shadow"
    Load "shadowfb"
    Load "dbe"
    Load "glx"
    Disable "dri"
EndSection' > /etc/X11/xorg.conf.d/20-modules.conf

lbu ci

# Setup Hud User
echo ""
echo "Setting up HUD user"
echo ""
adduser -h /home/hud_user -D -S

lbu ci

# Set up Kiosk mode as per http://blogs.wcode.org/2013/09/howto-boot-your-raspberry-pi-into-a-fullscreen-browser-kiosk/
echo ""
echo "Installing Kiosk Mode Boot files"
echo ""
curl https://raw.githubusercontent.com/VJftw/rpi-hud/develop/rpi-fs/boot/xinitrc -o /boot/xinitrc
chmod 755 /boot/xinitrc
curl https://raw.githubusercontent.com/VJftw/rpi-hud/develop/rpi-fs/boot/start.sh -o /home/hud_user/start.sh
chmod 755 /home/hud_user/start.sh
chown hud_user:hud_user /home/hud_user/start.sh

lbu ci