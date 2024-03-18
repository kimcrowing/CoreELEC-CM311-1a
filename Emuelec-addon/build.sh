#! /bin/bash

source_url="https://github.com/kimcrowing/EmuELEC.git"
echo " Welcome to build Emulelec-addon"
echo "Downloading Emulelec"
git clone -b dev $source_url

#PROJECT=Amlogic-ce DEVICE=Amlogic-ng ARCH=aarch64 DISTRO=EmuELEC make image
echo "Copy emuelec-addon.sh"
sudo \cp ./emuelec-addon.sh ./EmuELEC/
sudo chmod a+x ./EmuELEC/emuelec-addon.sh
cd EmuELEC
bash ./emuelec-addon.sh Amlogic-ce
