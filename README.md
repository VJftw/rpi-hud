# Raspberry Pi HUD

## Installation
1. Insert the microSD Card
2.
```

export MICROSD=/dev/sdc
export MSDPART=/dev/sdc1
sudo parted $MICROSD rm 1
sudo parted $MICROSD mkpart primary fat32 -a optimal 0% 100%
sudo parted $MICROSD set 1 boot on
sudo mkdir -p /mnt/microsd
sudo mount $MSDPART /mnt/microsd

curl -O http://dl-cdn.alpinelinux.org/alpine/v3.4/releases/armhf/alpine-rpi-3.4.0-armhf.rpi.tar.gz
sudo tar -xvzf alpine-rpi-3.4.0-armhf.rpi.tar.gz -C /mnt/microsd

sudo mkdir -p /mnt/microsd/firmware/brcm
sudo curl https://github.com/RPi-Distro/firmware-nonfree/raw/master/brcm80211/brcm/brcmfmac43430-sdio.bin -o /mnt/microsd/firmware/brcm/brcmfmac43430-sdio.bin

sudo curl https://github.com/RPi-Distro/firmware-nonfree/raw/master/brcm80211/brcm/brcmfmac43430-sdio.txt -o /mnt/microsd/firmware/brcm/brcmfmac43430-sdio.txt

```
