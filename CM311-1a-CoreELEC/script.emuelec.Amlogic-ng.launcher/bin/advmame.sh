#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

. /etc/profile

CONFIG_DIR="/storage/.advance"

if [ ! -d "$CONFIG_DIR" ]; then
 mkdir -p $CONFIG_DIR
 cp -rf /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/config/advance/* $CONFIG_DIR/
fi

if [[ "$1" = *"roms/arcade"* ]]; then 
sed -i "s|/roms/mame|/roms/arcade|g" $CONFIG_DIR/advmame.rc
 else
sed -i "s|/roms/arcade|/roms/mame|g" $CONFIG_DIR/advmame.rc
fi 

if [ "$EE_DEVICE" != "OdroidGoAdvance" ]; then

MODE=`cat /sys/class/display/mode`;
sed -i '/device_video_modeline/d' $CONFIG_DIR/advmame.rc

case "$MODE" in
"720p"*)
if [ -f /ee_s905 ]; then
	echo "device_video_modeline 1280x720-60 91.517 1280 1440 1531 1691 720 810 812 902 +hsync +vsync" >> $CONFIG_DIR/advmame.rc
fi
	;;
"1080p"*)
	echo "device_video_modeline 1920x1080_60.00 153.234 1920 1968 2121 2168 1080 1127 1130 1178 +hsync +vsync" >> $CONFIG_DIR/advmame.rc
	;;
esac

AUTOGP=$(get_ee_setting advmame_auto_gamepad)
[[ "${AUTOGP}" != "0" ]] && /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/bash /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/set_advmame_joy.sh

fi

ARG=$(echo basename $1 | sed 's/\.[^.]*$//')
ARG="$(echo $1 | sed 's=.*/==;s/\.[^.]*$//')"         

SDL_AUDIODRIVER=alsa /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/advmame $ARG -quiet
