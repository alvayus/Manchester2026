#!/bin/sh

# Install script for Linux distributions
# This is a basic installer that merely copies the include files and
# libraries to the system-wide directories.

# Location of udevadm depends on Linux distribution/version, but hopefully
# should be in one of these directories.
PATH=/sbin:/bin:/usr/sbin:/usr/bin

# Copy the udev rules file and reload all rules
cp ./60-opalkelly.rules /etc/udev/rules.d
udevadm control --reload-rules
udevadm trigger


# Copy the API libraries and include files
cp -a ./API/libokFrontPanel.so* /usr/local/lib/
cp ./API/okimpl_fpoip.so /usr/local/lib/
cp ./API/okFrontPanel.h /usr/local/include/
cp ./API/okFrontPanelDLL.h /usr/local/include/

if [ -d "./share/FrontPanel" ]; then
    cp -r ./share/FrontPanel /usr/local/share/

    if [ -d "/usr/share/applications" ]; then
        install -m 755 FrontPanel /usr/local/bin/
        install -m 755 FrontPanel.bin /usr/local/bin/

        install -m 644 ./Graphics/frontpanel.svg /usr/share/icons/hicolor/scalable/apps/
        install -m 644 ./Graphics/frontpanel.png /usr/share/icons/hicolor/256x256/apps/
        install -m 644  FrontPanel.desktop /usr/share/applications/
    else
        echo "Skipping FrontPanel GUI install, as /usr/share/applications does not exist."
    fi

fi
