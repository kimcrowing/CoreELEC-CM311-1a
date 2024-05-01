import xbmc, xbmcvfs, xbmcgui, xbmcplugin, xbmcaddon
import os
import util

dialog = xbmcgui.Dialog()
dialog.notification('EmuELEC', 'Launching....', xbmcgui.NOTIFICATION_INFO, 5000)

ADDON_ID = 'script.emuelec.Amlogic-ng.launcher'

addon = xbmcaddon.Addon(id=ADDON_ID)
addon_dir = xbmcvfs.translatePath( addon.getAddonInfo('path') )
addonfolder = addon.getAddonInfo('path')

icon = addonfolder + 'resources/icon.png'
fanart = addonfolder + 'resources/fanart.png'

util.runRetroarchMenu()