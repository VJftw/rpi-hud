#!/bin/bash

mkdir -p /rpi-hud
touch /rpi-hud/environment

echo ""
echo "Setting up"
echo ""
echo "Enter your ForecastIO API Key:"
read forecastio_key
echo FORECASTIO_API_KEY=$forecastio_key > /rpi-hud/environment


# Install Chromium Browser from Ubuntu Vivid PPA
echo ""
echo "Installing Chromium Browser"
echo ""
echo 'deb http://ppa.launchpad.net/canonical-chromium-builds/stage/ubuntu vivid main' > /etc/apt/sources.list.d/chromium-ppa.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DB69B232436DAC4B50BDC59E4E1B983C5B393194
apt-get update -y
apt-get install -y chromium-browser libexif12

# Install X11 and Matchbox
echo ""
echo "Installing X11 Server and Matchbox Window Manager"
echo ""
sudo apt-get install -y xserver-xorg xinit xwit matchbox

# Set up Kiosk mode as per http://blogs.wcode.org/2013/09/howto-boot-your-raspberry-pi-into-a-fullscreen-browser-kiosk/
echo ""
echo "Installing Kiosk Mode Boot files"
echo ""
curl https://raw.githubusercontent.com/VJftw/rpi-hud/master/rpi-fs/boot/config_ext.txt -o /boot/config_ext.txt
cat /boot/config_ext.txt > /boot/config.txt
curl https://raw.githubusercontent.com/VJftw/rpi-hud/master/rpi-fs/boot/xinitrc -o /boot/xinitrc
chmod 755 /boot/xinitrc
curl https://raw.githubusercontent.com/VJftw/rpi-hud/master/rpi-fs/etc/rc.local -o /etc/rc.local
chmod 755 /etc/rc.local


# Fix startx as per http://karuppuswamy.com/wordpress/2010/09/26/how-to-fix-x-user-not-authorized-to-run-the-x-server-aborting/
sed -i 's#.*allowed_users.*#allowed_users=anybody#g' /etc/X11/Xwrapper.config


# Set Local time TODO: make globaly friendly
sudo ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
