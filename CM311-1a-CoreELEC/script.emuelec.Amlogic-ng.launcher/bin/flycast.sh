#!/bin/bash

. /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/config/ee_env.sh

FLYCASTBIN="/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/flycast"

/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/setres.sh 16

mkdir -p "/storage/.local/share/"

if [ ! -L "/storage/.local/share/flycast" ]; then
    mkdir -p "/storage/roms/bios/dc"
    rm -rf "/storage/.local/share/flycast"
    ln -sf "/storage/roms/bios/dc" "/storage/.local/share/flycast"
fi

${FLYCASTBIN} "${1}"

/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/setres.sh
