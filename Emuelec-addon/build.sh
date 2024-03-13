source_url="https://github.com/EmuELEC/EmuELEC.git"

echo " Welcome to build Emulelec-addon""
echo "Downloading CEmulelec"
git clone ${source_url}
echo "Copy emuelec-addon.sh"
cd Emuelec
sudo cp Emuelec-addon/emuelec-addon.sh Emuelec/emuelec-addon.sh
sudo chown -x Emuelec/emuelec-addon.sh
