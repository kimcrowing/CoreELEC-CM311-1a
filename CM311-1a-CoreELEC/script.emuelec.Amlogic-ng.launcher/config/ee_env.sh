#!/bin/sh

. /etc/profile

oe_setup_addon script.emuelec.Amlogic-ng.launcher

export PATH="$ADDON_DIR/bin:$PATH"
export LD_LIBRARY_PATH="$ADDON_DIR/lib:$LD_LIBRARY_PATH"

# create symlinks to libraries
# ln -sf libxkbcommon.so.0.0.0 $ADDON_DIR/lib/libxkbcommon.so
# ln -sf libxkbcommon.so.0.0.0 $ADDON_DIR/lib/libxkbcommon.so.0
# ln -sf libvdpau.so.1.0.0 $ADDON_DIR/lib/libvdpau.so
# ln -sf libvdpau.so.1.0.0 $ADDON_DIR/lib/libvdpau.so.1
# ln -sf libvdpau_trace.so.1.0.0 $ADDON_DIR/lib/vdpau/libvdpau_trace.so
# ln -sf libvdpau_trace.so.1.0.0 $ADDON_DIR/lib/vdpau/libvdpau_trace.so.1
# ln -sf libdrm.so.2.4.0 $ADDON_DIR/lib/libdrm.so.2
# ln -sf libexif.so.12.3.3 $ADDON_DIR/lib/libexif.so.12

ln -sf libopenal.so.1.19.1 $ADDON_DIR/lib/libopenal.so.1
ln -sf libSDL2-2.0.so.0.9.0 $ADDON_DIR/lib/libSDL2-2.0.so.0
ln -sf libSDL2_mixer-2.0.so.0.2.2 $ADDON_DIR/lib/libSDL2_mixer-2.0.so.0
ln -sf libfreeimage-3.18.0.so $ADDON_DIR/lib/libfreeimage.so.3
ln -sf libvlc.so.5.6.0 $ADDON_DIR/lib/libvlc.so.5
ln -sf libvlccore.so.9.0.0 $ADDON_DIR/lib/libvlccore.so.9
ln -sf libvorbisidec.so.1.0.3 $ADDON_DIR/lib/libvorbisidec.so.1
ln -sf libpng16.so.16.36.0 $ADDON_DIR/lib/libpng16.so.16
ln -sf libmpg123.so.0.44.8 $ADDON_DIR/lib/libmpg123.so.0
ln -sf libout123.so.0.2.2 $ADDON_DIR/lib/libout123.so.0
ln -sf libSDL2_image-2.0.so.0.2.2 $ADDON_DIR/lib/libSDL2_image-2.0.so.0
ln -sf libSDL2_ttf-2.0.so.0.14.0 $ADDON_DIR/lib/libSDL2_ttf-2.0.so.0
ln -sf libFLAC.so.8.3.0 $ADDON_DIR/lib/libFLAC.so.8
ln -sf libmpeg2convert.so.0.0.0 $ADDON_DIR/lib/libmpeg2convert.so.0
ln -sf libmpeg2.so.0.1.0 $ADDON_DIR/lib/libmpeg2.so.0
ln -sf libSDL-1.2.so.0.11.5 $ADDON_DIR/lib/libSDL-1.2.so.0
ln -sf libSDL_net-1.2.so.0.8.0 $ADDON_DIR/lib/libSDL_net-1.2.so.0
ln -sf libcapsimage.so.5.1 $ADDON_DIR/lib/libcapsimage.so.5
ln -sf libzip.so.5.4 $ADDON_DIR/lib/libzip.so.5
ln -sf libzstd.so.1.4.3 $ADDON_DIR/lib/libzstd.so.1
mkdir -p /tmp/cache
