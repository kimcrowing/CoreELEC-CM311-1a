#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present SumavisionQ5 (https://github.com/SumavisionQ5)
# Modifications by Shanti Gilbert (https://github.com/shantigilbert)

# 12/07/2019 use mpv for all splash 
# 19/01/2020 use ffplay for all splash 
# 06/02/2020 move splash to roms folder and add global splash support

. /etc/profile

# Odroid Go Advance still does not support splash screens
if [ "$EE_DEVICE" == "OdroidGoAdvance" ]; then
	exit 0
fi

PLATFORM="$1"
GAMELOADINGSPLASH="/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/config/splash/loading-game.png"
DEFAULTSPLASH="/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/config/splash/splash-1080.png"
VIDEOSPLASH="/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/config/splash/emuelec_intro_1080p.mp4"
DURATION="5"

# we make sure the platform is all lowercase
PLATFORM=${PLATFORM,,}

case $PLATFORM in
 "arcade"|"fba"|"fbn"|"neogeo"|"mame"|cps*)
   PLATFORM="arcade"
  ;;
 "retropie"|"setup")
   # fbterm does not like the splash screen 
   exit 0
  ;;
esac

if [ "$PLATFORM" == "intro" ] || [ "$PLATFORM" == "exit" ]; then
	SPLASH=${DEFAULTSPLASH}
else
	SPLASHDIR="/storage/roms/splash"
	ROMNAME=$(basename "${2%.*}")
	SPLMAP="/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/config/bezels/arcademap.cfg"
	SPLNAME=$(sed -n "/`echo ""$PLATFORM"_"${ROMNAME}" = "`/p" "$SPLMAP")
	REALSPL="${SPLNAME#*\"}"
	REALSPL="${REALSPL%\"*}"
[ ! -z "$ROMNAME" ] && SPLASH1=$(find $SPLASHDIR/$PLATFORM -iname "$ROMNAME*.png" -maxdepth 1 | sort -V | head -n 1)
[ ! -z "$ROMNAME" ] && SPLASHVID1=$(find $SPLASHDIR/$PLATFORM -iname "$ROMNAME*.mp4" -maxdepth 1 | sort -V | head -n 1)
[ ! -z "$REALSPL" ] && SPLASH2=$(find $SPLASHDIR/$PLATFORM -iname "$REALSPL*.png" -maxdepth 1 | sort -V | head -n 1)
[ ! -z "$REALSPL" ] && SPLASHVID2=$(find $SPLASHDIR/$PLATFORM -iname "$REALSPL*.mp4" -maxdepth 1 | sort -V | head -n 1)

SPLASH3="$SPLASHDIR/$PLATFORM/launching.png"
SPLASHVID3="$SPLASHDIR/$PLATFORM/launching.mp4"

SPLASH4="$SPLASHDIR/$PLATFORM.png"
SPLASHVID4="$SPLASHDIR/$PLATFORM.mp4"

SPLASH5="$SPLASHDIR/launching.png"
SPLASHVID5="$SPLASHDIR/launching.mp4"
	
	if [ -f "$SPLASHVID1" ]; then
		SPLASH="$SPLASHVID1"
	elif [ -f "$SPLASH1" ]; then
		SPLASH="$SPLASH1"
	elif [ -f "$SPLASHVID2" ]; then
		SPLASH="$SPLASHVID2"
	elif [ -f "$SPLASH2" ]; then
		SPLASH="$SPLASH2"
	elif [ -f "$SPLASHVID3" ]; then
		SPLASH="$SPLASHVID3"
	elif [ -f "$SPLASH3" ]; then
		SPLASH="$SPLASH3"
	elif [ -f "$SPLASHVID4" ]; then
		SPLASH="$SPLASHVID4"
	elif [ -f "$SPLASH4" ]; then
		SPLASH="$SPLASH4"
	elif [ -f "$SPLASHVID5" ]; then
		SPLASH="$SPLASHVID5"
	elif [ -f "$SPLASH5" ]; then
		SPLASH="$SPLASH5"
	else
		SPLASH=${GAMELOADINGSPLASH}
	fi
fi

MODE=`cat /sys/class/display/mode`;
case "$MODE" in
		480*)
			SIZE=" -x 800 -y 480 "
		;;
		576*)
			SIZE=" -x 768 -y 576"
		;;
		720*)
			SIZE=" -x 1280 -y 720 "
		;;
		*)
			SIZE=" -x 1920 -y 1080"
		;;
esac

[[ "${PLATFORM}" != "intro" ]] && VIDEO=0 || VIDEO=$(get_ee_setting ee_bootvideo.enabled)

if [[ -f "/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/config/novideo" ]] && [[ ${VIDEO} != "1" ]]; then
	if [ "$PLATFORM" != "intro" ]; then
		ffplay -fs -autoexit ${SIZE} "${SPLASH}" > /dev/null 2>&1
	fi 
else
# Show intro video
	SPLASH=${VIDEOSPLASH}
	set_audio alsa
	#[ -e /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/config/asound.conf ] && mv /storage/.config/asound.conf /storage/.config/asound.confs
	ffplay -fs -autoexit ${SIZE} "$SPLASH" > /dev/null 2>&1
	touch "/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/config/novideo"
	#[ -e /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/config/asound.confs ] && mv /storage/.config/asound.confs /storage/.config/asound.conf
fi

# Wait for the time specified in ee_splash_delay setting in emuelec.conf
SPLASHTIME=$(get_ee_setting ee_splash.delay)
[ ! -z "$SPLASHTIME" ] && sleep $SPLASHTIME
