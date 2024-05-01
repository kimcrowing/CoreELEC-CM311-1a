# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

export LD_LIBRARY_PATH="/emuelec/lib:$LD_LIBRARY_PATH"
export PATH="/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/bin:/storage/.emulationstation/scripts:$PATH"

export SDL_GAMECONTROLLERCONFIG_FILE="/storage/.config/SDL-GameControllerDB/gamecontrollerdb.txt"

EE_DIR="/storage/.config/emuelec"
EE_CONF="${EE_DIR}/configs/emuelec.conf"
EE_EMUCONF=/emuelec/configs/emuoptions.conf
ES_CONF="/storage/.emulationstation/es_settings.cfg"
EE_DEVICE=$(cat /storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/config/ee_arch)
JSLISTENCONF="/emuelec/configs/jslisten.cfg"

get_ee_setting() {
# Argument $1 is the setting name, EmuELEC settings alway start with ee_ e.g. ee_novideo
# Usage: get_ee_setting setting [platform] [rom]
# Only the setting argument is required 
# Priority is: GAME, PLATFORM, GLOBAL, EE_SETTING if at any point one returns 0 it means its dissabled, if it returns empty it will continue onto the next one. 

SETTING="${1}"
PLATFORM="${2}"
ROM="${3}"

#ROM
ROM=$(echo [\"${ROM}\"] | sed -e 's|\[|\\\[|g' | sed -e 's|\]|\\\]|g' | sed -e 's|(|\\\(|g' | sed -e 's|)|\\\)|g')
PAT="^${PLATFORM}${ROM}[.-]${SETTING}=(.*)"
	EES=$(cat "${EE_EMUCONF}" | grep -oE "${PAT}")
	EES="${EES##*=}"

if [ -z "${EES}" ]; then
#PLATFORM
PAT="^${PLATFORM}[.-]${SETTING}=(.*)"
	EES=$(cat "${EE_EMUCONF}" | grep -oE "${PAT}")
	EES="${EES##*=}"
fi

if [ -z "${EES}" ]; then
#GLOBAL
PAT="^global[.-]${SETTING}=(.*)"
	EES=$(cat "${EE_CONF}" | grep -oE "${PAT}")
	EES="${EES##*=}"
fi

if [ -z "${EES}" ]; then
#EE_SETTINGS
PAT="^${SETTING}=(.*)"
	EES=$(cat "${EE_CONF}" | grep -oE "${PAT}")
	EES="${EES##*=}"
fi

echo "${EES}"	
}

set_ee_setting() {
# argument $1 is the setting name e.g. nes.integerscale. $2 is the value, e.g "1"
	sed -i "/$1=/d" "${EE_CONF}"
	[ $2 == "disable" ] && echo "#${1}=" >> "${EE_CONF}" || echo "${1}=${2}" >> "${EE_CONF}"
}

set_audio() { 
if [ "${1}" == "default" ]; then
	if [ "$EE_DEVICE" == "Amlogic" ] || [[ $(cat /proc/device-tree/coreelec-dt-id) == *"gxl_"* ]] ; then
	[ "$(get_ee_setting ee_alsa.always)" == 1 ] && AUDIO="alsa" || AUDIO="pulseaudio" 
	else
		AUDIO="alsa"
	fi
else
	AUDIO=${1}
fi
${EE_DIR}/scripts/rr_audio.sh ${AUDIO}
}

get_es_setting() { 
	echo $(sed -n "s|\s*<${1} name=\"${2}\" value=\"\(.*\)\" />|\1|p" ${ES_CONF})
}

init_port() {
sed -i "2s|program=.*|program=\"/usr/bin/killall ${1}\"|" ${JSLISTENCONF}

# If jslisten is running we kill it first so that it can reload the config file. 
killall jslisten

# JSLISTEN setup so that we can kill CGeniusExe using hotkey+start
/storage/.emulationstation/scripts/configscripts/z_getkillkeys.sh
/emuelec/bin/jslisten --mode hold &

set_audio ${2}
}

end_port() {
set_audio default

# Kill jslisten, we don't need to but just to make sure, dot not kill if using OdroidGoAdvance
[[ "$EE_DEVICE" != "OdroidGoAdvance" ]] && killall jslisten

# for some reason head sometimes does not exit
killall head
}

# used to change gov to performance or return to ondemand
maxperf() {
	
	if [ "$EE_DEVICE" == "OdroidGoAdvance" ]; then
		echo performance > /sys/devices/platform/ff400000.gpu/devfreq/ff400000.gpu/governor
		echo performance > /sys/devices/platform/dmc/devfreq/dmc/governor
		echo performance > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
	else
		echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
		echo "performance" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
		echo 5 > /sys/class/mpgpu/cur_freq
	fi
}

normperf() {
	if [ "$EE_DEVICE" == "OdroidGoAdvance" ]; then
		echo simple_ondemand > /sys/devices/platform/ff400000.gpu/devfreq/ff400000.gpu/governor
		echo dmc_ondemand > /sys/devices/platform/dmc/devfreq/dmc/governor
		echo interactive > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
	else
		echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
		echo "ondemand" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
		echo 1 > /sys/class/mpgpu/cur_freq
	fi	
}


ee_check_bios() {

PLATFORM="${1}"
CORE="${2}"
EMULATOR="${3}"
ROMNAME="${4}"
LOG="${5}"

if [[ -z "$LOG" ]]; then
	LOG="/storage/.kodi/addons/script.emuelec.Amlogic-ng.launcher/logs/emuelec.log"
	cat /etc/motd > "$LOG"
fi

MISSINGBIOS="$(batocera-systems --strictfilter ${PLATFORM})"
if [ "$?" == "2" ]; then

# formating so it looks nice :)
PLATFORMNAME="${MISSINGBIOS##*>}"  # read from -P onwards
PLATFORMNAME="${PLATFORMNAME%%MISSING*}"  # until a space is found
PLATFORMNAME=$(echo $PLATFORMNAME | sed -e 's/\\n//g')

if [[ -f "${LOG}" ]]; then
echo "${CORE} ${EMULATOR} ${ROMNAME}" >> $LOG
echo "${PLATFORMNAME} missing BIOS - Could not find all BIOS: " >> $LOG
echo "please make sure you copied the files into the corresponding folder " >> $LOG
echo "${MISSINGBIOS}" >> $LOG
fi
	MISSINGBIOS=$(echo "$MISSINGBIOS" | sed -e 's/$/\\n/g')
    
    if [[ "$EE_DEVICE" == "OdroidGoAdvance" ]]; then
		/emuelec/scripts/fbterm.sh error "${PLATFORMNAME} missing BIOS" "Could not find all BIOS/files in /storage/roms, the game may not work: \n\n ${MISSINGBIOS} \n\nPlease make sure you copied the files into the corresponding folder \n\nThis message will close in 10 seconds" &
		error_process="$!"
		sleep 10
		pkill -P $error_process
    else
		/emuelec/scripts/fbterm.sh error "${PLATFORMNAME} missing BIOS" "Could not find all BIOS/files in /storage/roms, the game may not work: \n\n ${MISSINGBIOS} \n\nPlease make sure you copied the files into the corresponding folder"
    fi
fi
}

# read config files from /storage/.config/profile.d
  for config in /storage/.config/profile.d/*; do
    if [ -f "$config" ] ; then
      . $config
    fi
done
