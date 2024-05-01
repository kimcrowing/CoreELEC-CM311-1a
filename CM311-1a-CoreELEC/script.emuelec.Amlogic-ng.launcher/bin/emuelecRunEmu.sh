#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

# This whole file has become very hacky, I am sure there is a better way to do all of this, but for now, this works.

arguments="$@"

#set audio device out according to emuelec.conf
AUDIO_DEVICE="hw:$(get_ee_setting audio_device)"
[ $AUDIO_DEVICE = "hw:" ] &&  AUDIO_DEVICE="hw:0,0"
# sed -i "s|pcm \"hw:.*|pcm \"${AUDIO_DEVICE}\"|" /storage/.config/asound.conf

# set audio to alsa
/storage/.emulationstation/scripts/bgm.sh stop

# Set the variables
CFG="/storage/.emulationstation/es_settings.cfg"
LOGEMU="No"
VERBOSE=""
LOGSDIR="/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/logs"
EMUELECLOG="$LOGSDIR/emuelec.log"
EMU=$(get_es_setting string EmuELEC_${1}_CORE)
TBASH="/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/bash"
JSLISTENCONF="/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/config/jslisten.cfg"
RATMPCONF="/tmp/retroarch/ee_retroarch.cfg"
RATMPCONF="/storage/.config/retroarch/retroarch.cfg"
set_kill_keys() {
	KILLTHIS=${1}
    sed -i '/program=.*/d' ${JSLISTENCONF}
	echo "program=\"/usr/bin/killall ${1}\"" >> ${JSLISTENCONF}
	}

# Make sure the /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/logs directory exists
if [[ ! -d "$LOGSDIR" ]]; then
mkdir -p "$LOGSDIR"
fi


# Extract the platform from the arguments in order to show the correct bezel/splash
if [[ "$arguments" == *"-P"* ]]; then
	PLATFORM="${arguments##*-P}"  # read from -P onwards
	PLATFORM="${PLATFORM%% *}"  # until a space is found
else
# if no -P was set, read the first argument as platform
	PLATFORM="$1"
fi

[ "$1" = "LIBRETRO" ] && ROMNAME="$3" || ROMNAME="$2"

# JSLISTEN setup so that we can kill running ALL emulators using hotkey+start
/storage/.emulationstation/scripts/configscripts/z_getkillkeys.sh
. ${JSLISTENCONF}

KILLDEV=${ee_evdev}
KILLTHIS="none"

# remove Libretro_ from the core name
EMU=$(echo "$EMU" | sed "s|Libretro_||")

# if there wasn't a --NOLOG included in the arguments, enable the emulator log output. TODO: this should be handled in ES menu
if [[ $arguments != *"--NOLOG"* ]]; then
LOGEMU="Yes"
VERBOSE="-v"
fi

# if the emulator is in es_settings this is the line that will run 
RUNTHIS='/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/retroarch $VERBOSE -L /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/lib/libretro/${EMU}_libretro.so --config ${RATMPCONF} "${ROMNAME}"'

# very WIP {

BEZ=$(get_es_setting bool BEZELS)
[ "$BEZ" == "true" ] && ${TBASH} /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/bezels.sh "$PLATFORM" "${ROMNAME}" || ${TBASH} /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/bezels.sh "default"
SPL=$(get_es_setting bool SPLASH)
[ "$SPL" == "true" ] && ${TBASH} /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/show_splash.sh "$PLATFORM" "${ROMNAME}" || ${TBASH} /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/show_splash.sh "default" 

# } very WIP 

# Read the first argument in order to set the right emulator
case $1 in
"HATARI")
	if [ "$EMU" = "HATARISA" ]; then
	set_kill_keys "hatari"
	RUNTHIS='${TBASH} /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/hatari.start "${ROMNAME}"'
	fi
	;;
"OPENBOR")
	set_kill_keys "OpenBOR"
	RUNTHIS='${TBASH} /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/openbor.sh "${ROMNAME}"'
	;;
"RETROPIE")
    set_kill_keys "fbterm"
	RUNTHIS='${TBASH} /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/fbterm.sh "${ROMNAME}"'
	EMUELECLOG="$LOGSDIR/ee_script.log"
	;;
"LIBRETRO")
	RUNTHIS='/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/retroarch $VERBOSE -L /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/lib/libretro/$2_libretro.so --config ${RATMPCONF} "${ROMNAME}"'
		;;
"REICAST")
	if [ "$EMU" = "FLYCASTSA" ]; then
	set_kill_keys "flycast"
	RUNTHIS='${TBASH} /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/flycast.sh "${ROMNAME}"'
	fi
	;;
"MAME"|"ARCADE")
	if [ "$EMU" = "AdvanceMame" ]; then
	set_kill_keys "advmame"
	RUNTHIS='${TBASH} /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/advmame.sh "${ROMNAME}"'
	fi
	;;
"DRASTIC")
	set_kill_keys "drastic"
	RUNTHIS='${TBASH} /storage/.emulationstation/scripts/drastic.sh "${ROMNAME}"'
		;;
"N64")
    if [ "$EMU" = "M64P" ]; then
    set_kill_keys "mupen64plus"
	RUNTHIS='${TBASH} /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/m64p.sh "${ROMNAME}"'
	fi
	;;
"AMIGA")
    if [ "$EMU" = "AMIBERRY" ]; then
    set_kill_keys "amiberry"
	RUNTHIS='${TBASH} /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/amiberry.start "${ROMNAME}"'
	fi
	;;
"SCUMMVM")
	RUNTHIS='/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/retroarch $VERBOSE -L /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/lib/libretro/scummvm_libretro.so --config ${RATMPCONF} "${ROMNAME}"'
	;;
"DOSBOX")
    if [ "$EMU" = "DOSBOXSDL2" ]; then
    set_kill_keys "dosbox"
	RUNTHIS='${TBASH} /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/dosbox.start "${ROMNAME}"'
	fi
	;;		
"PSP")
	if [ "$EMU" = "PPSSPPSA" ]; then
	#PPSSPP can run at 32BPP but only with buffered rendering, some games need non-buffered and the only way they work is if I set it to 16BPP
	# /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/setres.sh 16 # This was only needed for S912, but PPSSPP does not work on S912 
	set_kill_keys "ppsspp"
	RUNTHIS='${TBASH} /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/ppsspp.sh "${ROMNAME}"'
	fi
	;;
"NEOCD")
	if [ "$EMU" = "fbneo" ]; then
	RUNTHIS='/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/retroarch $VERBOSE -L /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/lib/libretro/fbneo_libretro.so --subsystem neocd --config ${RATMPCONF} "${ROMNAME}"'
	fi
	;;
esac

# If we are running a Libretro emulator set all the settings that we chose on ES
if [[ ${RUNTHIS} == *"libretro"* ]]; then
CORE=${EMU}
[ -z ${CORE} ] && CORE=${2}
echo ${CORE}
SHADERSET=$(/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/setsettings.sh "${PLATFORM}" "${ROMNAME}" "${CORE}")
echo $SHADERSET

if [[ ${SHADERSET} != 0 ]]; then
RUNTHIS=$(echo ${RUNTHIS} | sed "s|--config|${SHADERSET} --config|")
fi

fi
# Clear the log file
echo "EmuELEC Run Log" > $EMUELECLOG

# Write the command to the log file.
echo "PLATFORM: $PLATFORM" >> $EMUELECLOG
echo "ROM NAME: ${ROMNAME}" >> $EMUELECLOG
echo "USING CONFIG: ${RATMPCONF}" >> $EMUELECLOG
echo "1st Argument: $1" >> $EMUELECLOG 
echo "2nd Argument: $2" >> $EMUELECLOG
echo "3rd Argument: $3" >> $EMUELECLOG 
echo "4th Argument: $4" >> $EMUELECLOG 
echo "Run Command is:" >> $EMUELECLOG 
eval echo  ${RUNTHIS} >> $EMUELECLOG 

if [[ "$KILLTHIS" != "none" ]]; then

# We need to make sure there are at least 2 buttons setup (hotkey plus another) if not then do not load jslisten
	KKBUTTON1=$(sed -n "s|^button1=\(.*\)|\1|p" "${JSLISTENCONF}")
	KKBUTTON2=$(sed -n "s|^button2=\(.*\)|\1|p" "${JSLISTENCONF}")
	if [ ! -z $KKBUTTON1 ] && [ ! -z $KKBUTTON2 ]; then
		if [ ${KILLDEV} == "auto" ]; then
			/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/jslisten &>> ${EMUELECLOG} &
		else
			/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/jslisten --device /dev/input/${KILLDEV} &>> ${EMUELECLOG} &
		fi
	fi
fi

# Only run fbfix on N2
/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/fbfix

# Exceute the command and try to output the results to the log file if it was not dissabled.
if [[ $LOGEMU == "Yes" ]]; then
   echo "Emulator Output is:" >> $EMUELECLOG
   eval ${RUNTHIS} >> $EMUELECLOG 2>&1
else
   echo "Emulator log was dissabled" >> $EMUELECLOG
   eval ${RUNTHIS}
fi 

# Only run fbfix on N2
/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/fbfix

# Show exit splash
${TBASH} /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/show_splash.sh exit

# Kill jslisten, we don't need to but just to make sure 
killall jslisten

# Just for good measure lets make a symlink to Retroarch logs if it exists
if [[ -f "/storage/.config/retroarch/retroarch.log" ]]; then
	ln -sf /storage/.config/retroarch/retroarch.log ${LOGSDIR}/retroarch.log
fi

ln -sf /storage/.config/emuelec/logs/es_log.txt /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/logs/es_log.txt
ln -sf /storage/.config/emuelec/logs/es_log.txt.bak /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/logs/es_log.txt.bak

# Return to default mode
${TBASH} /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin/setres.sh

# reset audio to default
set_audio default
