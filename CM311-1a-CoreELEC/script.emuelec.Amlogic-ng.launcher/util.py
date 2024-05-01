import os, xbmc, xbmcvfs, xbmcaddon

ADDON_ID = 'script.emuelec.Amlogic-ng.launcher'
BIN_FOLDER="bin"
RETROARCH_EXEC="emuelec.sh"

addon = xbmcaddon.Addon(id=ADDON_ID)

def runRetroarchMenu():
    addon_dir = xbmcvfs.translatePath( addon.getAddonInfo('path') )
    bin_folder = os.path.join(addon_dir,BIN_FOLDER)
    retroarch_exe = os.path.join(bin_folder,RETROARCH_EXEC)
    os.system(retroarch_exe)