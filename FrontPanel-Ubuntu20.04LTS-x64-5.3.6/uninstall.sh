#!/bin/sh

# Uninstall script for Linux distributions
# This is a basic uninstaller that merely deletes the include files and
# libraries from the system-wide directories.

# Location of udevadm depends on Linux distribution/version, but hopefully
# should be in one of these directories.

PATH=/sbin:/bin:/usr/sbin:/usr/bin

rm /etc/udev/rules.d/60-opalkelly.rules
udevadm control --reload-rules
udevadm trigger

rm /usr/local/lib/libokFrontPanel.so*
rm /usr/local/lib/okimpl_fpoip.so
rm /usr/local/include/okFrontPanel.h
rm /usr/local/include/okFrontPanelDLL.h

if [ -d "./share/FrontPanel" ]; then
    rm -r /usr/local/share/FrontPanel/bitfiles
    rm -r /usr/local/share/FrontPanel/Sounds

    if [ -d "/usr/share/applications" ]; then
        rm /usr/local/bin/FrontPanel
        rm /usr/local/bin/FrontPanel.bin
        rm /usr/share/icons/hicolor/scalable/apps/frontpanel.svg
        rm /usr/share/icons/hicolor/256x256/apps/frontpanel.png

        rm /usr/share/applications/FrontPanel.desktop
    else
        echo "Skipping FrontPanel GUI uninstall, as /usr/share/applications does not exist."
    fi
fi
