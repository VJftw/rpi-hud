#!/bin/sh

echo ""
echo "WiFi Setup script"
echo ""

echo "-> Installing Dependencies: wireless-tools, wpa_supplicant"
apk add wireless-tools wpa_supplicant

echo "-> Enabling WiFi device"
ip link set wlan0 up

echo "-> Scanning for networks"
sleep 1
iwlist wlan0 scanning

echo "What is the SSID?"
read ssid
echo "SSID: $ssid"

echo "What is the WPA key?"
read wpakey
echo "WPA: $wpakey"

echo "-> Setting to connect to $ssid"
iwconfig wlan0 essid $ssid

echo "-> Generating WPA configuration"
mkdir -p /etc/wpa_supplicant
$wpakey > wpa_passphrase $ssid > /etc/wpa_supplicant/wpa.conf

echo "-> Setting network configuration"
cat << EOF > /etc/network/interfaces
auto wlan0
iface wlan0 inet dhcp
EOF

echo "-> Updating boot entry"
rc-update add wpa_supplicant boot

echo ""
echo "Done."
echo ""
