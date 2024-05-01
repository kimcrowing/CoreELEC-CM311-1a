#!/bin/sh

. /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/config/ee_env.sh

RA_CONFIG_DIR="/storage/.config/retroarch/"
RA_CONFIG_FILE="$RA_CONFIG_DIR/retroarch.cfg"
RA_CONFIG_SUBDIRS="savestates savefiles remappings playlists system thumbnails"
RA_EXE="$ADDON_DIR/bin/retroarch"
ROMS_FOLDER="/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/roms"
DOWNLOADS="downloads"
RA_PARAMS="--config=$RA_CONFIG_FILE --menu"
LOGFILE="$ADDON_DIR/logs/emuelec_addon.log"

if [ $ra_log -eq 1 ] ; then
	$RA_EXE $RA_PARAMS >$LOGFILE 2>&1
else
	$RA_EXE $RA_PARAMS
fi

rm -f /storage/.config/asound.conf
if [ "$ra_stop_kodi" -eq 1 ] ; then
	systemctl start kodi
else
	pgrep kodi.bin | xargs kill -SIGCONT
fi
