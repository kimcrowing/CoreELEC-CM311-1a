#! /bin/sh
source_url="https://github.com/EmuELEC/EmuELEC.git"
echo " Welcome to build Emulelec-addon"
echo "Downloading CEmulelec"
git clone https://github.com/EmuELEC/EmuELEC.git
ls
echo "Copy emuelec-addon.sh"
sudo cp ./emuelec-addon.sh ./EmuELEC/
sudo chown +x ./EmuELEC/emuelec-addon.sh
