
source_img_url="https://ghproxy.org/https://github.com/CoreELEC/CoreELEC/releases/download/${version}/${source_img_name}.img.gz"


echo " Welcome to build Emulelec-addon""
echo "Downloading CEmulelec"
git clone ${source_img_url}
echo "Copy addon.sh"
