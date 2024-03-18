#! /bin/sh

source_url="https://github.com/kimcrowing/EmuELEC.git"
echo " Welcome to build Emulelec-addon"
echo "Downloading Emulelec"
git clone -b dev $source_url
#cd EmuELEC
#PROJECT=Amlogic-ce DEVICE=Amlogic-ng ARCH=aarch64 DISTRO=EmuELEC make image
echo "Copy emuelec-addon.sh"
sudo \cp ./emuelec-addon.sh ./EmuELEC/
sudo chmod a+x ./EmuELEC/emuelec-addon.sh
./EmuELEC/emuelec-addon.sh "Amlogic-ce"
