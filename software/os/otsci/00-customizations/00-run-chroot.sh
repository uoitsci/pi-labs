# Current setup expects piserver DNS record
echo "172.16.192.138            piserver" >> /etc/hosts

# Campus DNS servers
{
    echo "nameserver 205.211.180.196"
    echo "nameserver 205.211.181.196"
} > /etc/resolv.conf

# Set raspi-config settings
/usr/bin/raspi-config nonint do_i2c 0 # Enable I2C
/usr/bin/raspi-config nonint do_browser firefox # Firefox
/usr/bin/raspi-config nonint do_change_timezone America/Toronto
/usr/bin/raspi-config nonint do_change_locale en_CA.UTF-8
/usr/bin/raspi-config nonint do_configure_keyboard us
/usr/bin/raspi-config nonint do_boot_behaviour B3 # Boot to GUI login
#/usr/bin/raspi-config nonint do_wayland W1 # Use X11

# Moved to Wayland after pi-gen commit a125344 broke X11
# https://github.com/RPi-Distro/pi-gen/issues/756

# Show all kernel messages
sed -i 's# quiet##g' /boot/firmware/cmdline.txt

# RPi.GPIO is no longer supported on RPi 5
apt remove -y python3-rpi.gpio

# Install required Python module(s)
pip3 install --break-system-packages adafruit-circuitpython-ht16k33 \
    rpi-lgpio

# Remove CUPS and printing support
apt-get remove -y -q cups-\* system-config-printer\* geany

echo "disable_splash=1" >> /boot/firmware/config.txt

# Set HDMI output on port 0 to 1080p@60 Hz since students frequently plug
# in the monitor after power.  Also defaults keyboard to function mode
# so students can use F5 to run programs in IDLE.
sed -i 's/$/ video=HDMI-A-1:1920x1080@60D hid_apple.fnmode=2/' /boot/firmware/cmdline.txt

# Allow passwordless sudo for science user
echo "science ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/010_science-nopasswd

# Add a local admin account
#userdel slocal || true
#adduser --disabled-password --shell /bin/bash --gecos "Local Science Account" slocal
#usermod -aG sudo slocal
#echo -n "slocal:slocal" | chpasswd

# Fix Wayfire keyboard settings


# Required for LGPIO to function properly (https://github.com/joan2937/lg/issues/12)
echo "export LG_WD=/tmp" >> /etc/bash.bashrc

cat <<EOF>/tmp/eeprom-config.txt
[all]
BOOT_ORDER=0xf21
HDMI_DELAY=0
EOF

rpi-eeprom-config --config /tmp/eeprom-config.txt --out /boot/firmware/pieeprom.upd \
    /lib/firmware/raspberrypi/bootloader-2712/latest/pieeprom-2024-02-16.bin
rpi-eeprom-digest -i /boot/firmware/pieeprom.upd -o /boot/firmware/pieeprom.sig
