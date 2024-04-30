#!/bin/bash

install -m 644 files/nologo_1080x1920-ontariotech_desktop.jpg "${ROOTFS_DIR}/usr/share/rpd-wallpaper/RPiSystem.png"
install -m 644 files/desktop_1080x1920-ontariotech.jpg "${ROOTFS_DIR}/usr/share/rpd-wallpaper/fisherman.jpg"
install -b -m 755 files/idle-launcher.py "${ROOTFS_DIR}/usr/bin/idle"
install -b -m 755 files/thonny-launcher.py "${ROOTFS_DIR}/usr/bin/thonny"
install -b -m 644 files/pi-greeter.mo "${ROOTFS_DIR}/usr/share/locale/en_CA/LC_MESSAGES/pi-greeter.mo"

# There are two IDLE entries.  The first points to the system default Python interpreter
# and the second explicitly points to 3.11.
sed '0,/$/{s/$/.11/}' "${ROOTFS_DIR}/usr/bin/idle" > "${ROOTFS_DIR}/usr/bin/idle-python3.11"