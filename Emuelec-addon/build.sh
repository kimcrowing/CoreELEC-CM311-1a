#! /bin/sh
source_url="https://github.com/EmuELEC/EmuELEC.git"
echo " Welcome to build Emulelec-addon"
echo "Downloading Emulelec"
git clone https://github.com/EmuELEC/EmuELEC.git
ls
echo "Copy emuelec-addon.sh"
sudo cp ./emuelec-addon.sh ./EmuELEC/
sudo chmod a+x ./EmuELEC/emuelec-addon.sh
