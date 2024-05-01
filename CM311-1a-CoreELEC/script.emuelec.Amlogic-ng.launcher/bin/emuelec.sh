#!/bin/sh

. /etc/profile

oe_setup_addon script.emuelec.Amlogic-ng.launcher

systemd-run $ADDON_DIR/bin/emuelec.start
